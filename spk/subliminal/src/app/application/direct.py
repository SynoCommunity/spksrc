from babelfish import Language
from configobj import ConfigObj
from datetime import timedelta
from db import *
from pyextdirect.configuration import (create_configuration, expose, LOAD,
    STORE_READ, STORE_CUD, SUBMIT)
from validate import Validator
import os
import shutil
import subliminal
import subprocess
import tempfile



__all__ = ['Base', 'Directories', 'Subliminal']


Base = create_configuration()


class Directories(Base):
    def __init__(self):
        self.session = Session()

    @expose(kind=STORE_CUD)
    def create(self, data):
        results = []
        for record in data:
            directory = Directory(name=record['name'], path=record['path'])
            self.session.add(directory)
            self.session.commit()
            results.append({'id': directory.id, 'name': directory.name, 'path': directory.path})
        return results

    @expose(kind=STORE_READ)
    def read(self):
        results = []
        for directory in self.session.query(Directory).all():
            results.append({'id': directory.id, 'name': directory.name, 'path': directory.path})
        return results

    @expose(kind=STORE_CUD)
    def update(self, data):
        results = []
        for record in data:
            directory = self.session.query(Directory).get(record['id'])
            directory.name = record['name']
            directory.path = record['path']
            results.append({'id': directory.id, 'name': directory.name, 'path': directory.path})
        self.session.commit()
        return results

    @expose(kind=STORE_CUD)
    def destroy(self, data):
        results = []
        for directory_id in data:
            directory = self.session.query(Directory).get(directory_id)
            self.session.delete(directory)
            results.append(directory.id)
        self.session.commit()
        return results

    @expose
    def scan(self, directory_id):
        with open(os.devnull, 'w') as devnull:
            subprocess.call(['/usr/local/subliminal/app/scanner.py', str(directory_id)], stdin=devnull, stdout=devnull, stderr=devnull)


class Subliminal(Base):
    config_path = '/usr/local/subliminal/var/config.ini'

    def __init__(self):
        self.session = Session()
        self.config = ConfigObj(self.config_path, configspec='/usr/local/subliminal/app/application/config.spec', encoding='utf-8')
        self.config_validator = Validator()
        self.config.validate(self.config_validator)

    def setup(self):
        self.config.validate(self.config_validator, copy=True)
        self.config.write()

    @expose(kind=LOAD)
    def load(self):
        result = {'languages': self.config['General']['languages'], 'providers': self.config['General']['providers'],
                  'single': self.config['General']['single'], 'hearing_impaired': self.config['General']['hearing_impaired'],
                  'min_score': self.config['General']['min_score'], 'dsm_notifications': self.config['General']['dsm_notifications'],
                  'task': self.config['Task']['enable'], 'age': self.config['Task']['age'],
                  'hour': self.config['Task']['hour'], 'minute': self.config['Task']['minute']}
        return result

    @expose(kind=SUBMIT)
    def save(self, languages=None, providers=None, single=None, hearing_impaired=None, min_score=None, dsm_notifications=None, task=None, age=None, hour=None, minute=None):
        self.config['General']['languages'] = languages if isinstance(languages, list) else [languages]
        self.config['General']['providers'] = providers if isinstance(providers, list) else [providers]
        self.config['General']['single'] = bool(single)
        self.config['General']['hearing_impaired'] = bool(hearing_impaired)
        self.config['General']['min_score'] = int(min_score)
        self.config['General']['dsm_notifications'] = bool(dsm_notifications)
        self.config['Task']['enable'] = bool(task)
        self.config['Task']['age'] = int(age)
        self.config['Task']['hour'] = int(hour)
        self.config['Task']['minute'] = int(minute)
        if not self.config.validate(self.config_validator):
            return
        self.config.write()

    def scan(self):
        paths = [directory.path for directory in self.session.query(Directory).all() if os.path.exists(directory.path)]
        if not paths:
            return
        results = scan(paths, self.config)
        if self.config['General']['dsm_notifications']:
            notify('Downloaded %d subtitle(s) for %d video(s) in all directories' % (sum([len(s) for s in results.itervalues()]), len(results)))
        return results


def scan(paths, config):
    subliminal.cache_region.configure('dogpile.cache.dbm', arguments={'filename': '/usr/local/subliminal/cache/cachefile.dbm'})
    languageset=set(Language(language) for language in config['General']['languages'])
    single=True
    if not config.get('General').as_bool('single') or len(languageset) > 1:
        single=False	     
    hearing_impaired=None
    if config.get('General').as_bool('hearing_impaired'):
        hearing_impaired=True
    videos = subliminal.scan_videos(paths, subtitles=True, embedded_subtitles=True, age=timedelta(days=config.get('Task').as_int('age')))
    subtitles = subliminal.api.download_best_subtitles(videos, languages=languageset, providers=config['General']['providers'], provider_configs=None, 
                                                       single=single, min_score=config.get('General').as_int('min_score'), 
                                                       hearing_impaired=hearing_impaired)
    return subtitles

def notify(message):
    with open(os.devnull, 'w') as devnull:
        subprocess.call(['synodsmnotify', '@administrators', 'Subliminal', message], stdin=devnull, stdout=devnull, stderr=devnull)
