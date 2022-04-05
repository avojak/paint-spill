conf_data = configuration_data()
conf_data.set('APP_ID', application_id)
conf_data.set('APP_NAME', application_name)
conf_data.set('VERSION', meson.project_version())

config_header = configure_file(
    input: 'config.vala.in',
    output: 'config.vala',
    configuration: conf_data
)

application_files = files(
    join_paths('Layouts', 'MainLayout.vala'),
    join_paths('Models', 'Color.vala'),
    join_paths('Models', 'Difficulty.vala'),
    join_paths('Services', 'ActionManager.vala'),
    join_paths('Widgets', 'Dialogs', 'DefeatDialog.vala'),
    join_paths('Widgets', 'Dialogs', 'DifficultyChangeWarningDialog.vala'),
    join_paths('Widgets', 'Dialogs', 'GameplayStatisticsDialog.vala'),
    join_paths('Widgets', 'Dialogs', 'NewGameConfirmationDialog.vala'),
    join_paths('Widgets', 'Dialogs', 'ResetGameplayStatisticsWarningDialog.vala'),
    join_paths('Widgets', 'Dialogs', 'RulesDialog.vala'),
    join_paths('Widgets', 'Dialogs', 'VictoryDialog.vala'),
    join_paths('Widgets', 'ColorButton.vala'),
    join_paths('Widgets', 'ColorControlPanel.vala'),
    join_paths('Widgets', 'GameBoard.vala'),
    join_paths('Widgets', 'GameplayStatistics.vala'),
    join_paths('Widgets', 'HeaderBar.vala'),
    join_paths('Widgets', 'Rules.vala'),
    join_paths('Widgets', 'Square.vala'),
    join_paths('Windows', 'MainWindow.vala'),
    join_paths('Application.vala')
)

# Create a new executable, list the files we want to compile, list the dependencies we need, and install
executable(
    application_id,
    application_files,
    config_header,
    # css_gresource,
    dependencies: [
        dependency('gtk+-3.0', version: '>= 3.24.20'),
        dependency('gee-0.8', version: '>= 0.20.3'),
        dependency('glib-2.0', version: '>= 2.64.6'),
        dependency('granite', version: '>= 6.2.0'),
        dependency('libhandy-1', version: '>= 1.2.0')
    ],
    vala_args: vala_args,
    install: true
)
