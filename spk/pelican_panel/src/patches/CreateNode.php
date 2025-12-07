<?php

namespace App\Filament\Admin\Resources\Nodes\Pages;

use App\Filament\Admin\Resources\Nodes\NodeResource;
use App\Models\Node;
use App\Traits\Filament\CanCustomizeHeaderActions;
use App\Traits\Filament\CanCustomizeHeaderWidgets;
use Exception;
use Filament\Actions\Action;
use Filament\Forms\Components\Hidden;
use Filament\Forms\Components\TagsInput;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\ToggleButtons;
use Filament\Resources\Pages\CreateRecord;
use Filament\Schemas\Components\Grid;
use Filament\Schemas\Components\Utilities\Get;
use Filament\Schemas\Components\Utilities\Set;
use Filament\Schemas\Components\Wizard;
use Filament\Schemas\Components\Wizard\Step;
use Filament\Schemas\Schema;
use Illuminate\Support\Facades\Blade;
use Illuminate\Support\HtmlString;

class CreateNode extends CreateRecord
{
    use CanCustomizeHeaderActions;
    use CanCustomizeHeaderWidgets;

    protected static string $resource = NodeResource::class;

    protected static bool $canCreateAnother = false;

    /**
     * @throws Exception
     */
    public function form(Schema $schema): Schema
    {
        return $schema
            ->components([
                Wizard::make([
                    Step::make('basic')
                        ->label(trans('admin/node.tabs.basic_settings'))
                        ->icon('tabler-server')
                        ->columnSpanFull()
                        ->columns([
                            'default' => 2,
                            'sm' => 3,
                            'md' => 3,
                            'lg' => 4,
                        ])
                        ->schema([
                            TextInput::make('fqdn')
                                ->columnSpan(2)
                                ->required()
                                ->autofocus()
                                ->live(debounce: 1500)
                                ->rules(Node::getRulesForField('fqdn'))
                                ->prohibited(fn ($state) => is_ip($state) && request()->isSecure())
                                ->label(fn ($state) => is_ip($state) ? trans('admin/node.ip_address') : trans('admin/node.domain'))
                                ->placeholder(fn ($state) => is_ip($state) ? '192.168.1.1' : 'node.example.com')
                                ->helperText(function ($state) {
                                    if (is_ip($state)) {
                                        if (request()->isSecure()) {
                                            return trans('admin/node.fqdn_help');
                                        }

                                        return '';
                                    }

                                    return trans('admin/node.error');
                                })
                                ->hintColor('danger')
                                ->hint(function ($state) {
                                    if (is_ip($state) && request()->isSecure()) {
                                        return trans('admin/node.ssl_ip');
                                    }

                                    return '';
                                })
                                ->afterStateUpdated(function (Set $set, ?string $state) {
                                    $set('dns', null);
                                    $set('ip', null);

                                    [$subdomain] = str($state)->explode('.', 2);
                                    if (!is_numeric($subdomain)) {
                                        $set('name', $subdomain);
                                    }

                                    if (!$state || is_ip($state)) {
                                        $set('dns', null);

                                        return;
                                    }

                                    $ip = get_ip_from_hostname($state);
                                    if ($ip) {
                                        $set('dns', true);

                                        $set('ip', $ip);
                                    } else {
                                        $set('dns', false);
                                    }
                                })
                                ->maxLength(255),

                            TextInput::make('ip')
                                ->disabled()
                                ->hidden(),

                            ToggleButtons::make('dns')
                                ->label(trans('admin/node.dns'))
                                ->helperText(trans('admin/node.dns_help'))
                                ->disabled()
                                ->inline()
                                ->default(null)
                                ->hint(fn (Get $get) => $get('ip'))
                                ->hintColor('success')
                                ->options([
                                    true => trans('admin/node.valid'),
                                    false => trans('admin/node.invalid'),
                                ])
                                ->colors([
                                    true => 'success',
                                    false => 'danger',
                                ])
                                ->columnSpan([
                                    'default' => 1,
                                    'sm' => 1,
                                    'md' => 1,
                                    'lg' => 1,
                                ]),

                            TextInput::make('daemon_connect')
                                ->columnSpan(1)
                                ->label(fn (Get $get) => $get('connection') === 'https_proxy' ? trans('admin/node.connect_port') : trans('admin/node.port'))
                                ->helperText(fn (Get $get) => $get('connection') === 'https_proxy' ? trans('admin/node.connect_port_help') : trans('admin/node.port_help'))
                                ->minValue(1)
                                ->maxValue(65535)
                                ->default(8445)
                                ->required()
                                ->integer(),

                            TextInput::make('name')
                                ->label(trans('admin/node.display_name'))
                                ->columnSpan([
                                    'default' => 1,
                                    'sm' => 1,
                                    'md' => 1,
                                    'lg' => 2,
                                ])
                                ->required()
                                ->maxLength(100),

                            Hidden::make('scheme')
                                ->default(fn () => request()->isSecure() ? 'https' : 'http'),

                            Hidden::make('behind_proxy')
                                ->default(false),

                            ToggleButtons::make('connection')
                                ->label(trans('admin/node.ssl'))
                                ->columnSpan(1)
                                ->inline()
                                ->helperText(function (Get $get) {
                                    if (request()->isSecure()) {
                                        return new HtmlString(trans('admin/node.panel_on_ssl'));
                                    }

                                    if (is_ip($get('fqdn'))) {
                                        return trans('admin/node.ssl_help');
                                    }

                                    return '';
                                })
                                ->disableOptionWhen(fn (string $value) => $value === 'http' && request()->isSecure())
                                ->options([
                                    'http' => 'HTTP',
                                    'https' => 'HTTPS (SSL)',
                                    'https_proxy' => 'HTTPS with (reverse) proxy',
                                ])
                                ->colors([
                                    'http' => 'warning',
                                    'https' => 'success',
                                    'https_proxy' => 'success',
                                ])
                                ->icons([
                                    'http' => 'tabler-lock-open-off',
                                    'https' => 'tabler-lock',
                                    'https_proxy' => 'tabler-shield-lock',
                                ])
                                ->default(fn () => request()->isSecure() ? 'https' : 'http')
                                ->live()
                                ->dehydrated(false)
                                ->afterStateUpdated(function ($state, Set $set) {
                                    $set('scheme', $state === 'http' ? 'http' : 'https');
                                    $set('behind_proxy', $state === 'https_proxy');

                                    $set('daemon_connect', $state === 'https_proxy' ? 443 : 8445);
                                    $set('daemon_listen', 8445);
                                }),

                            TextInput::make('daemon_listen')
                                ->columnSpan(1)
                                ->label(trans('admin/node.listen_port'))
                                ->helperText(trans('admin/node.listen_port_help'))
                                ->minValue(1)
                                ->maxValue(65535)
                                ->default(8445)
                                ->required()
                                ->integer()
                                ->visible(fn (Get $get) => $get('connection') === 'https_proxy'),
                        ]),
                    Step::make('advanced')
                        ->label(trans('admin/node.tabs.advanced_settings'))
                        ->icon('tabler-server-cog')
                        ->columnSpanFull()
                        ->columns([
                            'default' => 2,
                            'sm' => 3,
                            'md' => 3,
                            'lg' => 4,
                        ])
                        ->schema([
                            ToggleButtons::make('maintenance_mode')
                                ->label(trans('admin/node.maintenance_mode'))->inline()
                                ->columnSpan(1)
                                ->default(false)
                                ->hintIcon('tabler-question-mark', trans('admin/node.maintenance_mode_help'))
                                ->options([
                                    true => trans('admin/node.enabled'),
                                    false => trans('admin/node.disabled'),
                                ])
                                ->colors([
                                    true => 'danger',
                                    false => 'success',
                                ]),
                            ToggleButtons::make('public')
                                ->default(true)
                                ->columnSpan(1)
                                ->label(trans('admin/node.use_for_deploy'))->inline()
                                ->options([
                                    true => trans('admin/node.yes'),
                                    false => trans('admin/node.no'),
                                ])
                                ->colors([
                                    true => 'success',
                                    false => 'danger',
                                ]),
                            TagsInput::make('tags')
                                ->label(trans('admin/node.tags'))
                                ->columnSpan(2),
                            TextInput::make('upload_size')
                                ->label(trans('admin/node.upload_limit'))
                                ->helperText(trans('admin/node.upload_limit_help.0'))
                                ->hintIcon('tabler-question-mark', trans('admin/node.upload_limit_help.1'))
                                ->columnSpan(1)
                                ->numeric()->required()
                                ->default(256)
                                ->minValue(1)
                                ->maxValue(1024)
                                ->suffix(config('panel.use_binary_prefix') ? 'MiB' : 'MB'),
                            TextInput::make('daemon_sftp')
                                ->columnSpan(1)
                                ->label(trans('admin/node.sftp_port'))
                                ->minValue(1)
                                ->maxValue(65535)
                                ->default(2022)
                                ->required()
                                ->integer(),
                            TextInput::make('daemon_sftp_alias')
                                ->columnSpan(2)
                                ->label(trans('admin/node.sftp_alias'))
                                ->helperText(trans('admin/node.sftp_alias_help')),
                            Grid::make()
                                ->columns(6)
                                ->columnSpanFull()
                                ->schema([
                                    ToggleButtons::make('unlimited_mem')
                                        ->dehydrated()
                                        ->label(trans('admin/node.memory'))->inlineLabel()->inline()
                                        ->afterStateUpdated(fn (Set $set) => $set('memory', 0))
                                        ->afterStateUpdated(fn (Set $set) => $set('memory_overallocate', 0))
                                        ->formatStateUsing(fn (Get $get) => $get('memory') == 0)
                                        ->live()
                                        ->options([
                                            true => trans('admin/node.unlimited'),
                                            false => trans('admin/node.limited'),
                                        ])
                                        ->colors([
                                            true => 'primary',
                                            false => 'warning',
                                        ])
                                        ->columnSpan(2),
                                    TextInput::make('memory')
                                        ->dehydratedWhenHidden()
                                        ->hidden(fn (Get $get) => $get('unlimited_mem'))
                                        ->label(trans('admin/node.memory_limit'))->inlineLabel()
                                        ->suffix(config('panel.use_binary_prefix') ? 'MiB' : 'MB')
                                        ->columnSpan(2)
                                        ->numeric()
                                        ->minValue(0)
                                        ->default(0)
                                        ->required(),
                                    TextInput::make('memory_overallocate')
                                        ->dehydratedWhenHidden()
                                        ->label(trans('admin/node.overallocate'))->inlineLabel()
                                        ->hidden(fn (Get $get) => $get('unlimited_mem'))
                                        ->columnSpan(2)
                                        ->numeric()
                                        ->minValue(-1)
                                        ->maxValue(100)
                                        ->default(0)
                                        ->suffix('%')
                                        ->required(),
                                ]),
                            Grid::make()
                                ->columns(6)
                                ->columnSpanFull()
                                ->schema([
                                    ToggleButtons::make('unlimited_disk')
                                        ->dehydrated()
                                        ->label(trans('admin/node.disk'))->inlineLabel()->inline()
                                        ->live()
                                        ->afterStateUpdated(fn (Set $set) => $set('disk', 0))
                                        ->afterStateUpdated(fn (Set $set) => $set('disk_overallocate', 0))
                                        ->formatStateUsing(fn (Get $get) => $get('disk') == 0)
                                        ->options([
                                            true => trans('admin/node.unlimited'),
                                            false => trans('admin/node.limited'),
                                        ])
                                        ->colors([
                                            true => 'primary',
                                            false => 'warning',
                                        ])
                                        ->columnSpan(2),
                                    TextInput::make('disk')
                                        ->dehydratedWhenHidden()
                                        ->hidden(fn (Get $get) => $get('unlimited_disk'))
                                        ->label(trans('admin/node.disk_limit'))->inlineLabel()
                                        ->suffix(config('panel.use_binary_prefix') ? 'MiB' : 'MB')
                                        ->columnSpan(2)
                                        ->numeric()
                                        ->minValue(0)
                                        ->default(0)
                                        ->required(),
                                    TextInput::make('disk_overallocate')
                                        ->dehydratedWhenHidden()
                                        ->hidden(fn (Get $get) => $get('unlimited_disk'))
                                        ->label(trans('admin/node.overallocate'))->inlineLabel()
                                        ->columnSpan(2)
                                        ->numeric()
                                        ->minValue(-1)
                                        ->maxValue(100)
                                        ->default(0)
                                        ->suffix('%')
                                        ->required(),
                                ]),
                            Grid::make()
                                ->columns(6)
                                ->columnSpanFull()
                                ->schema([
                                    ToggleButtons::make('unlimited_cpu')
                                        ->dehydrated()
                                        ->label(trans('admin/node.cpu'))->inlineLabel()->inline()
                                        ->live()
                                        ->afterStateUpdated(fn (Set $set) => $set('cpu', 0))
                                        ->afterStateUpdated(fn (Set $set) => $set('cpu_overallocate', 0))
                                        ->formatStateUsing(fn (Get $get) => $get('cpu') == 0)
                                        ->options([
                                            true => trans('admin/node.unlimited'),
                                            false => trans('admin/node.limited'),
                                        ])
                                        ->colors([
                                            true => 'primary',
                                            false => 'warning',
                                        ])
                                        ->columnSpan(2),
                                    TextInput::make('cpu')
                                        ->dehydratedWhenHidden()
                                        ->hidden(fn (Get $get) => $get('unlimited_cpu'))
                                        ->label(trans('admin/node.cpu_limit'))->inlineLabel()
                                        ->suffix('%')
                                        ->columnSpan(2)
                                        ->numeric()
                                        ->default(0)
                                        ->minValue(0)
                                        ->required(),
                                    TextInput::make('cpu_overallocate')
                                        ->dehydratedWhenHidden()
                                        ->hidden(fn (Get $get) => $get('unlimited_cpu'))
                                        ->label(trans('admin/node.overallocate'))->inlineLabel()
                                        ->columnSpan(2)
                                        ->numeric()
                                        ->default(0)
                                        ->minValue(-1)
                                        ->maxValue(100)
                                        ->suffix('%')
                                        ->required(),
                                ]),
                        ]),
                ])->columnSpanFull()
                    ->nextAction(fn (Action $action) => $action->label(trans('admin/node.next_step')))
                    ->submitAction(new HtmlString(Blade::render(<<<'BLADE'
                                        <x-filament::button
                                                type="submit"
                                                size="sm"
                                            >
                                                {{ trans('admin/node.create') }}
                                            </x-filament::button>
                                        BLADE))),
            ]);
    }

    protected function getRedirectUrlParameters(): array
    {
        return [
            'tab' => 'configuration-file::data::tab',
        ];
    }

    protected function getFormActions(): array
    {
        return [];
    }

    protected function mutateFormDataBeforeCreate(array $data): array
    {
        if (!$data['behind_proxy']) {
            $data['daemon_listen'] = $data['daemon_connect'];
        }

        return $data;
    }
}
