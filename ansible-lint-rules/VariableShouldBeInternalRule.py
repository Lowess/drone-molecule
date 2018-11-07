
import six
from ansiblelint import AnsibleLintRule


class VariableShouldBeInternalRule(AnsibleLintRule):
    id = 'GG0001'
    shortdesc = 'The variable should be internal and prefixed with __'
    description = 'The variable should be internal and prefixed with a double _ ' + \
        'Please update "{{ your_variable }}" -> "{{ __your_variable }}".'
    tags = ['formatting']

    _commands = ['set_fact']

    def matchtask(self, file, task):
        if 'set_fact' in task["action"]["__ansible_module__"]:
            for k, v in six.iteritems(task["action"]):
                if not k.startswith('__'):
                    return True

        if 'register' in task:
            return not task["register"].startswith('__')

        return
