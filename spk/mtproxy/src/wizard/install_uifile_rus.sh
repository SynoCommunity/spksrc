#!/bin/sh

SECRET="$(dd if=/dev/urandom bs=16 count=1 2>&1 | od -tx1  | head -n1 | tail -c +9 | tr -d ' ' | tr '[:upper:]' '[:lower:]')"
IP="$(curl -s -4 "https://digitalresistance.dog/myIp")"

WIZARD_CONTENT="$(cat << 'EOF'
[{
    "step_title": "Настройки сервера",
    "invalid_next_disabled": true,
    "items": [{
        "desc": "Пожалуйста, прочитайте <a href=\"https://github.com/TelegramMessenger/MTProxy/blob/master/README.md\" target=\"_blank\">документацию MTProxy</a> перед началом"
    }, {
        "type": "textfield",
        "subitems": [{
            "key": "wizard_proxy_internal_ip",
            "desc": "Внутренний IP адрес",
            "defaultValue": "",
            "validator": {
                "allowBlank": true,
                "regex": {
                    "expr": "/^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/",
                    "errorText": "Некорректный IP адрес"
                }
            }
        }]
    }, {
        "type": "textfield",
        "subitems": [{
            "key": "wizard_proxy_external_ip",
            "desc": "Внешний IP адрес",
            "defaultValue": "",
            "validator": {
                "allowBlank": true,
                "regex": {
                    "expr": "/^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/",
                    "errorText": "Некорректный IP адрес"
                }
            }
        }]
    }, {
        "desc": "Оставьте IP адреса пустыми, если вы их не знаете или у вас динамические адреса"
    }, {
        "type": "textfield",
        "subitems": [{
            "key": "wizard_proxy_port",
            "desc": "Порт сервера",
            "defaultValue": "1984",
            "validator": {
                "allowBlank": false,
                "regex": {
                    "expr": "/^[1-9][0-9]{2,4}$/",
                    "errorText": "Порт должен быть в диапазоне 100-65535"
                }
            }
        }]
    }, {
        "type": "textfield",
        "subitems": [{
            "key": "wizard_proxy_workers",
            "desc": "Количество процессов",
            "defaultValue": "2",
            "validator": {
                "allowBlank": false,
                "regex": {
                    "expr": "/^([1-9]|1[0-6])$/",
                    "errorText": "Может быть от 1 до 16 процессов"
                }
            }
        }]
    }]
}, {
    "step_title": "Конфигурация MTProto",
    "invalid_next_disabled": true,
    "items": [{
        "type": "textfield",
        "subitems": [{
            "key": "wizard_proxy_secrets",
            "desc": "Ключи доступа (через запятую)",
            "defaultValue": "@proxy_secret@",
            "validator": {
                "allowBlank": false,
                "regex": {
                    "expr": "/^[0-9a-fA-F]{32}(,[0-9a-fA-F]{32}){0,15}$/",
                    "errorText": "Ключи должны состоять из 32 символов и разделяться запятой"
                }
            }
        }]
    }, {
        "type": "textfield",
        "subitems": [{
            "key": "wizard_proxy_tag",
            "desc": "Тэг",
            "defaultValue": "",
            "validator": {
                "allowBlank": true,
                "regex": {
                    "expr": "/^[0-9a-fA-F]{32}$/",
                    "errorText": "Тэг должен содержать 32 символа"
                }
            }
        }]
    }, {
        "desc": "Вы можете получить тэг у <a href=\"https://t.me/MTProxybot\" target=\"_blank\">@MTProxybot</a> после регистрации вашего прокси"
    }]
}, {
    "step_title": "Информация",
    "invalid_next_disabled": true,
    "activeate": "{(function(step,ip){if(step.getNext()!=='applyStep'){return}var d=document,p=d.querySelector('input[name=\"wizard_proxy_port\"]').value,$l=d.getElementById('wizard_proxy_tg_link'),$t=d.getElementById('wizard_proxy_tg_links'),r=d.querySelector('input[name=\"wizard_proxy_secrets\"]').value.split(',').map(function(k){return 'tg://proxy?server='+ip+'&port='+p+'&secret='+k}).join(\"\\n\");$t.value=r;$l.href=URL.createObjectURL(new Blob([r]))}).call(this,arguments[0],'@proxy_ip@');}",
    "items": [{
        "desc": "<h3>Ваши ссылки для настройки прокси, сохраните их:</h3>"
    }, {
        "desc": "<textarea readonly wrap=\"off\" id=\"wizard_proxy_tg_links\" class=\"x-form-text x-form-field syno-ux-textfield x-item-disabled\" style=\"width:100%;height:10em;overflow:auto;background-image:none;margin-bottom:4px\"></textarea><a href=\"#\" id=\"wizard_proxy_tg_link\" download=\"MTProxy.txt\">Скачать файл со ссылками</a>"
    }, {
        "type": "multiselect",
        "subitems": [{
            "key": "wizard_proxy_confirm",
            "desc": "Я сохранил ссылки",
            "defaultVaule": false,
            "validator": {
                "fn": "{return arguments[0];}"
             }
        }]
    }]
}]
EOF
)"

OUTPUT=$(echo $WIZARD_CONTENT | sed "s#@proxy_secret@#${SECRET}#g" | sed "s#@proxy_ip@#${IP}#g")

echo $OUTPUT > $SYNOPKG_TEMP_LOGFILE
exit 0
