# Project name and programming language
project('com.github.avojak.paint-spill', 'vala', 'c', version: '1.2.0')

i18n = import('i18n')
gnome = import('gnome')

vala_args = ['--pkg', 'posix']

application_id = meson.project_name()
application_name = 'Paint Spill'

# Set our translation domain
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()), language: 'c')

subdir('data')
subdir('src')
# subdir('test')
subdir('po')

meson.add_install_script('meson/post_install.py')
