# translate/forms.py
from django import forms

from .models import Translation


class TranslationForm(forms.ModelForm):
    class Meta:
        model = Translation
        fields = [ 'source', 'input', 'target', 'output']


    def __init__(self, translation=None, *args, **kwargs):
        try:
            data = {
                'source': translation.source,
                'input' : translation.input,
                'target': translation.target,
                'output': translation.output
            }
        except AttributeError:
            data = translation

        super().__init__(data, *args, **kwargs)

