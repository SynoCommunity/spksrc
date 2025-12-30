<?php

namespace App\Filament\Admin\Resources\Nodes\Pages;

use App\Filament\Admin\Resources\Nodes\NodeResource;
use App\Models\Node;
use App\Repositories\Daemon\DaemonSystemRepository;
use App\Services\Helpers\SoftwareVersionService;
use App\Services\Nodes\NodeAutoDeployService;
use App\Services\Nodes\NodeUpdateService;
use App\Traits\Filament\CanCustomizeHeaderActions;
use App\Traits\Filament\CanCustomizeHeaderWidgets;
use Exception;
use Filament\Actions\Action;
use Filament\Actions\DeleteAction;
use Filament\Forms\Components\Hidden;
use Filament\Forms\Components\Slider;
use Filament\Forms\Components\Slider\Enums\PipsMode;
use Filament\Forms\Components\TagsInput;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\ToggleButtons;
use Filament\Infolists\Components\CodeEntry;
use Filament\Infolists\Components\TextEntry;
use Filament\Notifications\Notification;
use Filament\Resources\Pages\EditRecord;
use Filament\Schemas\Components\Actions;
use Filament\Schemas\Components\Fieldset;
use Filament\Schemas\Components\Grid;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Components\StateCasts\BooleanStateCast;
use Filament\Schemas\Components\Tabs;
use Filament\Schemas\Components\Tabs\Tab;
use Filament\Schemas\Components\Utilities\Get;
use Filament\Schemas\Components\Utilities\Set;
use Filament\Schemas\Components\View;
use Filament\Schemas\Schema;
use Filament\Support\Enums\Alignment;
use Filament\Support\Enums\IconSize;
use Filament\Support\RawJs;
use Illuminate\Http\Client\ConnectionException;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\HtmlString;
use Phiki\Grammar\Grammar;
use Throwable;

class EditNode extends EditRecord
{
    use CanCustomizeHeaderActions;
    use CanCustomizeHeaderWidgets;

    protected static string $resource = NodeResource::class;

    private DaemonSystemRepository $daemonSystemRepository;

    private NodeUpdateService $nodeUpdateService;

    public function boot(DaemonSystemRepository $daemonSystemRepository, NodeUpdateService $nodeUpdateService): void
    {
        $this->daemonSystemRepository = $daemonSystemRepository;
        $this->nodeUpdateService = $nodeUpdateService;
    }

    /**
     * @throws Throwable
     */
    public function form(Schema $schema): Schema
    {
        return $schema->components([
            Tabs::make('Tabs')
                ->columns([
                    'default' => 2,
                    'sm' => 3,
                    'md' => 3,
                    'lg' => 4,
                ])
                ->persistTabInQueryString()
                ->columnSpanFull()
                ->tabs([
                    Tab::make('overview')
                        ->label(trans('admin/node.tabs.overview'))
                        ->icon('tabler-chart-area-line-filled')
                        ->columns([
                            'default' => 4,
                            'sm' => 2,
                            'md' => 4,
                            'lg' => 4,
                        ])
                        ->schema([
                            Fieldset::make()
                                ->label(trans('admin/node.node_info'))
                                ->columns(4)
                                ->columnSpanFull()
                                ->schema([
                                    TextEntry::make('wings_version')
                                        ->label(trans('admin/node.wings_version'))
                                        ->state(fn (Node $node, SoftwareVersionService $versionService) => ($node->systemInformation()['version'] ?? trans('admin/node.unknown')) . ' ' . trans('admin/node.latest', ['version' => $versionService->latestWingsVersion()])),
                                    TextEntry::make('cpu_threads')
                                        ->label(trans('admin/node.cpu_threads'))
                                        ->state(fn (Node $node) => $node->systemInformation()['cpu_count'] ?? 0),
                                    TextEntry::make('architecture')
                                        ->label(trans('admin/node.architecture'))
                                        ->state(fn (Node $node) => $node->systemInformation()['architecture'] ?? trans('admin/node.unknown')),
                                    TextEntry::make('kernel')
                                        ->label(trans('admin/node.kernel'))
                                        ->state(fn (Node $node) => $node->systemInformation()['kernel_version'] ?? trans('admin/node.unknown')),
                                ]),
                            View::make('filament.components.node-cpu-chart')
                                ->columnSpan([
                                    'default' => 4,
                                    'sm' => 1,
                                    'md' => 2,
                                    'lg' => 2,
                                ]),
                            View::make('filament.components.node-memory-chart')
                                ->columnSpan([
                                    'default' => 4,
                                    'sm' => 1,
                                    'md' => 2,
                                    'lg' => 2,
                                ]),
                            View::make('filament.components.node-storage-chart')
                                ->columnSpanFull(),
                        ]),
                    Tab::make('basic_settings')
                        ->label(trans('admin/node.tabs.basic_settings'))
                        ->icon('tabler-server')
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
                                ->stateCast(new BooleanStateCast(false, true))
                                ->options([
                                    1 => trans('admin/node.valid'),
                                    0 => trans('admin/node.invalid'),
                                ])
                                ->colors([
                                    1 => 'success',
                                    0 => 'danger',
                                ])
                                ->columnSpan(1),
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
                            Hidden::make('scheme'),
                            Hidden::make('behind_proxy'),
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
                                ->formatStateUsing(fn (Get $get) => $get('scheme') === 'http' ? 'http' : ($get('behind_proxy') ? 'https_proxy' : 'https'))
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
                    Tab::make('advanced_settings')
                        ->label(trans('admin/node.tabs.advanced_settings'))
                        ->columns([
                            'default' => 1,
                            'sm' => 1,
                            'md' => 4,
                            'lg' => 6,
                        ])
                        ->icon('tabler-server-cog')
                        ->schema([
                            TextInput::make('id')
                                ->label(trans('admin/node.node_id'))
                                ->columnSpan([
                                    'default' => 1,
                                    'sm' => 1,
                                    'md' => 2,
                                    'lg' => 1,
                                ])
                                ->disabled(),
                            TextInput::make('uuid')
                                ->columnSpan([
                                    'default' => 1,
                                    'sm' => 1,
                                    'md' => 2,
                                    'lg' => 2,
                                ])
                                ->label(trans('admin/node.node_uuid'))
                                ->hintCopy()
                                ->disabled(),
                            TagsInput::make('tags')
                                ->label(trans('admin/node.tags'))
                                ->placeholder('')
                                ->columnSpan([
                                    'default' => 1,
                                    'sm' => 1,
                                    'md' => 2,
                                    'lg' => 2,
                                ]),
                            TextInput::make('upload_size')
                                ->columnSpan([
                                    'default' => 1,
                                    'sm' => 1,
                                    'md' => 2,
                                    'lg' => 1,
                                ])
                                ->label(trans('admin/node.upload_limit'))
                                ->hintIcon('tabler-question-mark', trans('admin/node.upload_limit_help.0') . trans('admin/node.upload_limit_help.1'))
                                ->numeric()->required()
                                ->minValue(1)
                                ->maxValue(1024)
                                ->suffix(config('panel.use_binary_prefix') ? 'MiB' : 'MB'),
                            TextInput::make('daemon_sftp')
                                ->columnSpan([
                                    'default' => 1,
                                    'sm' => 1,
                                    'md' => 1,
                                    'lg' => 3,
                                ])
                                ->label(trans('admin/node.sftp_port'))
                                ->minValue(1)
                                ->maxValue(65535)
                                ->default(2022)
                                ->required()
                                ->integer(),
                            TextInput::make('daemon_sftp_alias')
                                ->columnSpan([
                                    'default' => 1,
                                    'sm' => 1,
                                    'md' => 1,
                                    'lg' => 3,
                                ])
                                ->label(trans('admin/node.sftp_alias'))
                                ->helperText(trans('admin/node.sftp_alias_help')),
                            ToggleButtons::make('public')
                                ->columnSpan([
                                    'default' => 1,
                                    'sm' => 1,
                                    'md' => 1,
                                    'lg' => 3,
                                ])
                                ->label(trans('admin/node.use_for_deploy'))
                                ->inline()
                                ->stateCast(new BooleanStateCast(false, true))
                                ->options([
                                    1 => trans('admin/node.yes'),
                                    0 => trans('admin/node.no'),
                                ])
                                ->colors([
                                    1 => 'success',
                                    0 => 'danger',
                                ]),
                            ToggleButtons::make('maintenance_mode')
                                ->columnSpan([
                                    'default' => 1,
                                    'sm' => 1,
                                    'md' => 1,
                                    'lg' => 3,
                                ])
                                ->label(trans('admin/node.maintenance_mode'))
                                ->inline()
                                ->hintIcon('tabler-question-mark', trans('admin/node.maintenance_mode_help'))
                                ->stateCast(new BooleanStateCast(false, true))
                                ->options([
                                    1 => trans('admin/node.enabled'),
                                    0 => trans('admin/node.disabled'),
                                ])
                                ->colors([
                                    1 => 'danger',
                                    0 => 'success',
                                ]),
                            Grid::make()
                                ->columns([
                                    'default' => 1,
                                    'sm' => 1,
                                    'md' => 3,
                                    'lg' => 6,
                                ])
                                ->columnSpanFull()
                                ->schema([
                                    ToggleButtons::make('unlimited_mem')
                                        ->dehydrated()
                                        ->label(trans('admin/node.memory'))->inlineLabel()->inline()
                                        ->afterStateUpdated(fn (Set $set) => $set('memory', 0))
                                        ->afterStateUpdated(fn (Set $set) => $set('memory_overallocate', 0))
                                        ->formatStateUsing(fn (Get $get) => $get('memory') == 0)
                                        ->live()
                                        ->stateCast(new BooleanStateCast(false, true))
                                        ->options([
                                            1 => trans('admin/node.unlimited'),
                                            0 => trans('admin/node.limited'),
                                        ])
                                        ->colors([
                                            1 => 'primary',
                                            0 => 'warning',
                                        ])
                                        ->columnSpan([
                                            'default' => 1,
                                            'sm' => 1,
                                            'md' => 1,
                                            'lg' => 2,
                                        ]),
                                    TextInput::make('memory')
                                        ->dehydratedWhenHidden()
                                        ->hidden(fn (Get $get) => $get('unlimited_mem'))
                                        ->label(trans('admin/node.memory_limit'))->inlineLabel()
                                        ->suffix(config('panel.use_binary_prefix') ? 'MiB' : 'MB')
                                        ->required()
                                        ->columnSpan([
                                            'default' => 1,
                                            'sm' => 1,
                                            'md' => 1,
                                            'lg' => 2,
                                        ])
                                        ->numeric()
                                        ->minValue(0),
                                    TextInput::make('memory_overallocate')
                                        ->dehydratedWhenHidden()
                                        ->label(trans('admin/node.overallocate'))->inlineLabel()
                                        ->required()
                                        ->hidden(fn (Get $get) => $get('unlimited_mem'))
                                        ->columnSpan([
                                            'default' => 1,
                                            'sm' => 1,
                                            'md' => 1,
                                            'lg' => 2,
                                        ])
                                        ->numeric()
                                        ->minValue(-1)
                                        ->maxValue(100)
                                        ->suffix('%'),
                                ]),
                            Grid::make()
                                ->columnSpanFull()
                                ->columns([
                                    'default' => 1,
                                    'sm' => 1,
                                    'md' => 3,
                                    'lg' => 6,
                                ])
                                ->schema([
                                    ToggleButtons::make('unlimited_disk')
                                        ->dehydrated()
                                        ->label(trans('admin/node.disk'))->inlineLabel()->inline()
                                        ->live()
                                        ->afterStateUpdated(fn (Set $set) => $set('disk', 0))
                                        ->afterStateUpdated(fn (Set $set) => $set('disk_overallocate', 0))
                                        ->formatStateUsing(fn (Get $get) => $get('disk') == 0)
                                        ->stateCast(new BooleanStateCast(false, true))
                                        ->options([
                                            1 => trans('admin/node.unlimited'),
                                            0 => trans('admin/node.limited'),
                                        ])
                                        ->colors([
                                            1 => 'primary',
                                            0 => 'warning',
                                        ])
                                        ->columnSpan([
                                            'default' => 1,
                                            'sm' => 1,
                                            'md' => 1,
                                            'lg' => 2,
                                        ]),
                                    TextInput::make('disk')
                                        ->dehydratedWhenHidden()
                                        ->hidden(fn (Get $get) => $get('unlimited_disk'))
                                        ->label(trans('admin/node.disk_limit'))->inlineLabel()
                                        ->suffix(config('panel.use_binary_prefix') ? 'MiB' : 'MB')
                                        ->required()
                                        ->columnSpan([
                                            'default' => 1,
                                            'sm' => 1,
                                            'md' => 1,
                                            'lg' => 2,
                                        ])
                                        ->numeric()
                                        ->minValue(0),
                                    TextInput::make('disk_overallocate')
                                        ->dehydratedWhenHidden()
                                        ->hidden(fn (Get $get) => $get('unlimited_disk'))
                                        ->label(trans('admin/node.overallocate'))->inlineLabel()
                                        ->columnSpan([
                                            'default' => 1,
                                            'sm' => 1,
                                            'md' => 1,
                                            'lg' => 2,
                                        ])
                                        ->required()
                                        ->numeric()
                                        ->minValue(-1)
                                        ->maxValue(100)
                                        ->suffix('%'),
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
                                        ->stateCast(new BooleanStateCast(false, true))
                                        ->options([
                                            1 => trans('admin/node.unlimited'),
                                            0 => trans('admin/node.limited'),
                                        ])
                                        ->colors([
                                            1 => 'primary',
                                            0 => 'warning',
                                        ])
                                        ->columnSpan(2),
                                    TextInput::make('cpu')
                                        ->dehydratedWhenHidden()
                                        ->hidden(fn (Get $get) => $get('unlimited_cpu'))
                                        ->label(trans('admin/node.cpu_limit'))->inlineLabel()
                                        ->suffix('%')
                                        ->required()
                                        ->columnSpan(2)
                                        ->numeric()
                                        ->minValue(0),
                                    TextInput::make('cpu_overallocate')
                                        ->dehydratedWhenHidden()
                                        ->hidden(fn (Get $get) => $get('unlimited_cpu'))
                                        ->label(trans('admin/node.overallocate'))->inlineLabel()
                                        ->columnSpan(2)
                                        ->required()
                                        ->numeric()
                                        ->minValue(-1)
                                        ->maxValue(100)
                                        ->suffix('%'),
                                ]),
                        ]),
                    Tab::make('config_file')
                        ->label(trans('admin/node.tabs.config_file'))
                        ->icon('tabler-code')
                        ->schema([
                            TextEntry::make('instructions')
                                ->label(trans('admin/node.instructions'))
                                ->columnSpanFull()
                                ->state(new HtmlString(trans('admin/node.instructions_help'))),
                            CodeEntry::make('config')
                                ->label('/etc/pelican/config.yml')
                                ->grammar(Grammar::Yaml)
                                ->state(fn (Node $node) => $node->getYamlConfiguration())
                                ->copyable()
                                ->disabled()
                                ->columnSpanFull(),
                            Grid::make()
                                ->columns()
                                ->columnSpanFull()
                                ->schema([
                                    Actions::make([
                                        Action::make('autoDeploy')
                                            ->label(trans('admin/node.auto_deploy'))
                                            ->color('primary')
                                            ->modalHeading(trans('admin/node.auto_deploy'))
                                            ->icon('tabler-rocket')
                                            ->modalSubmitAction(false)
                                            ->modalCancelAction(false)
                                            ->modalFooterActionsAlignment(Alignment::Center)
                                            ->schema([
                                                ToggleButtons::make('docker')
                                                    ->label(trans('admin/node.auto_label'))
                                                    ->live()
                                                    ->helperText(trans('admin/node.auto_question'))
                                                    ->inline()
                                                    ->default(false)
                                                    ->afterStateUpdated(fn (bool $state, NodeAutoDeployService $service, Node $node, Set $set) => $set('generatedToken', $service->handle(request(), $node, $state)))
                                                    ->stateCast(new BooleanStateCast(false, true))
                                                    ->options([
                                                        0 => trans('admin/node.standalone'),
                                                        1 => trans('admin/node.docker'),
                                                    ])
                                                    ->colors([
                                                        0 => 'primary',
                                                        1 => 'success',
                                                    ])
                                                    ->columnSpan(1),
                                                Textarea::make('generatedToken')
                                                    ->label(trans('admin/node.auto_command'))
                                                    ->readOnly()
                                                    ->autosize()
                                                    ->hintCopy()
                                                    ->formatStateUsing(fn (NodeAutoDeployService $service, Node $node, Set $set, Get $get) => $set('generatedToken', $service->handle(request(), $node, $get('docker')))),
                                            ])
                                            ->mountUsing(function (Schema $schema) {
                                                $schema->fill();
                                            }),
                                    ])->fullWidth(),
                                    Actions::make([
                                        Action::make('resetKey')
                                            ->label(trans('admin/node.reset_token'))
                                            ->color('danger')
                                            ->requiresConfirmation()
                                            ->modalHeading(trans('admin/node.reset_token'))
                                            ->modalDescription(trans('admin/node.reset_help'))
                                            ->action(function (Node $node) {
                                                try {
                                                    $this->nodeUpdateService->handle($node, [], true);
                                                } catch (Exception) {
                                                    Notification::make()
                                                        ->title(trans('admin/node.error_connecting', ['node' => $node->name]))
                                                        ->body(trans('admin/node.error_connecting_description'))
                                                        ->color('warning')
                                                        ->icon('tabler-database')
                                                        ->warning()
                                                        ->send();

                                                }
                                                Notification::make()->success()->title(trans('admin/node.token_reset'))->send();
                                                $this->fillForm();
                                            }),
                                    ])->fullWidth(),
                                ]),
                        ]),
                    Tab::make('diagnostics')
                        ->label(trans('admin/node.tabs.diagnostics'))
                        ->icon('tabler-heart-search')
                        ->schema([
                            Section::make('diag')
                                ->heading(trans('admin/node.tabs.diagnostics'))
                                ->columnSpanFull()
                                ->columns(4)
                                ->disabled(fn (Get $get) => $get('pulled'))
                                ->headerActions([
                                    Action::make('pull')
                                        ->label(trans('admin/node.diagnostics.pull'))
                                        ->icon('tabler-cloud-download')->iconButton()->iconSize(IconSize::ExtraLarge)
                                        ->hidden(fn (Get $get) => $get('pulled'))
                                        ->action(function (Get $get, Set $set, Node $node) {
                                            $includeEndpoints = $get('include_endpoints') ?? true;
                                            $includeLogs = $get('include_logs') ?? true;
                                            $logLines = $get('log_lines') ?? 200;

                                            try {
                                                $response = $this->daemonSystemRepository->setNode($node)->getDiagnostics($logLines, $includeEndpoints, $includeLogs);

                                                if ($response->status() === 404) {
                                                    Notification::make()
                                                        ->title(trans('admin/node.diagnostics.404'))
                                                        ->warning()
                                                        ->send();

                                                    return;
                                                }

                                                $set('pulled', true);
                                                $set('uploaded', false);
                                                $set('log', $response->body());

                                                Notification::make()
                                                    ->title(trans('admin/node.diagnostics.logs_pulled'))
                                                    ->success()
                                                    ->send();
                                            } catch (ConnectionException $e) {
                                                Notification::make()
                                                    ->title(trans('admin/node.error_connecting', ['node' => $node->name]))
                                                    ->body($e->getMessage())
                                                    ->danger()
                                                    ->send();

                                            }
                                        }),
                                    Action::make('upload')
                                        ->label(trans('admin/node.diagnostics.upload'))
                                        ->visible(fn (Get $get) => $get('pulled') ?? false)
                                        ->icon('tabler-cloud-upload')->iconButton()->iconSize(IconSize::ExtraLarge)
                                        ->action(function (Get $get, Set $set) {
                                            try {
                                                $response = Http::asMultipart()->post('https://logs.pelican.dev', [
                                                    [
                                                        'name' => 'c',
                                                        'contents' => $get('log'),
                                                    ],
                                                    [
                                                        'name' => 'e',
                                                        'contents' => '14d',
                                                    ],
                                                ]);

                                                if ($response->failed()) {
                                                    Notification::make()
                                                        ->title(trans('admin/node.diagnostics.upload_failed'))
                                                        ->body(fn () => $response->status() . ' - ' . $response->body())
                                                        ->danger()
                                                        ->send();

                                                    return;
                                                }

                                                $data = $response->json();
                                                $url = $data['url'];

                                                Notification::make()
                                                    ->title(trans('admin/node.diagnostics.logs_uploaded'))
                                                    ->body("{$url}")
                                                    ->success()
                                                    ->actions([
                                                        Action::make('viewLogs')
                                                            ->label(trans('admin/node.diagnostics.view_logs'))
                                                            ->url($url)
                                                            ->openUrlInNewTab(true),
                                                    ])
                                                    ->persistent()
                                                    ->send();
                                                $set('log', $url);
                                                $set('pulled', false);
                                                $set('uploaded', true);

                                            } catch (\Exception $e) {
                                                Notification::make()
                                                    ->title(trans('admin/node.diagnostics.upload_failed'))
                                                    ->body($e->getMessage())
                                                    ->danger()
                                                    ->send();
                                            }
                                        }),
                                    Action::make('clear')
                                        ->label(trans('admin/node.diagnostics.clear'))
                                        ->visible(fn (Get $get) => $get('pulled') ?? false)
                                        ->icon('tabler-trash')->iconButton()->iconSize(IconSize::ExtraLarge)->color('danger')
                                        ->action(function (Get $get, Set $set) {
                                            $set('pulled', false);
                                            $set('uploaded', false);
                                            $set('log', null);
                                            $this->refresh();
                                        }
                                        ),
                                ])
                                ->schema([
                                    ToggleButtons::make('include_endpoints')
                                        ->hintIcon('tabler-question-mark')->inline()
                                        ->hintIconTooltip(trans('admin/node.diagnostics.include_endpoints_hint'))
                                        ->formatStateUsing(fn () => 1)
                                        ->boolean(),
                                    ToggleButtons::make('include_logs')
                                        ->live()
                                        ->hintIcon('tabler-question-mark')->inline()
                                        ->hintIconTooltip(trans('admin/node.diagnostics.include_logs_hint'))
                                        ->formatStateUsing(fn () => 1)
                                        ->boolean(),
                                    Slider::make('log_lines')
                                        ->columnSpan(2)
                                        ->hiddenLabel()
                                        ->live()
                                        ->tooltips(RawJs::make(<<<'JS'
                                            `${$value} lines`
                                            JS))
                                        ->visible(fn (Get $get) => $get('include_logs'))
                                        ->range(minValue: 100, maxValue: 500)
                                        ->pips(PipsMode::Steps, density: 10)
                                        ->step(50)
                                        ->formatStateUsing(fn () => 200)
                                        ->fillTrack(),
                                    Hidden::make('pulled'),
                                    Hidden::make('uploaded'),
                                ]),
                            Textarea::make('log')
                                ->hiddenLabel()
                                ->columnSpanFull()
                                ->rows(35)
                                ->visible(fn (Get $get) => ($get('pulled') ?? false) || ($get('uploaded') ?? false)),
                        ]),
                ]),
        ]);
    }

    protected function mutateFormDataBeforeFill(array $data): array
    {
        $node = Node::findOrFail($data['id']);

        if (!is_ip($node->fqdn)) {
            $ip = get_ip_from_hostname($node->fqdn);
            if ($ip) {
                $data['dns'] = true;
                $data['ip'] = $ip;
            } else {
                $data['dns'] = false;
            }
        }

        return $data;
    }

    protected function getFormActions(): array
    {
        return [];
    }

    /** @return array<Action|Actions> */
    protected function getDefaultHeaderActions(): array
    {
        return [
            DeleteAction::make()
                ->disabled(fn (Node $node) => $node->servers()->count() > 0)
                ->label(fn (Node $node) => $node->servers()->count() > 0 ? trans('admin/node.node_has_servers') : trans('filament-actions::delete.single.label')),
            $this->getSaveFormAction()->formId('form'),
        ];
    }

    protected function mutateFormDataBeforeSave(array $data): array
    {
        if (!$data['behind_proxy']) {
            $data['daemon_listen'] = $data['daemon_connect'];
        }

        return $data;
    }

    protected function afterSave(): void
    {
        $this->fillForm();

        /** @var Node $node */
        $node = $this->record;

        $changed = collect($node->getChanges())->except(['updated_at', 'name', 'tags', 'public', 'maintenance_mode', 'memory', 'memory_overallocate', 'disk', 'disk_overallocate', 'cpu', 'cpu_overallocate'])->all();

        try {
            if ($changed) {
                $this->daemonSystemRepository->setNode($node)->update($node);
            }
            parent::getSavedNotification()?->send();
        } catch (ConnectionException) {
            Notification::make()
                ->title(trans('admin/node.error_connecting', ['node' => $node->name]))
                ->body(trans('admin/node.error_connecting_description'))
                ->color('warning')
                ->icon('tabler-database')
                ->warning()
                ->send();
        }
    }

    protected function getSavedNotification(): ?Notification
    {
        return null;
    }

    protected function getColumnSpan(): ?int
    {
        return null;
    }

    protected function getColumnStart(): ?int
    {
        return null;
    }
}
