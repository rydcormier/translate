# translate/views.py
from django.shortcuts import render

from .forms import TranslationForm


def translate(request):
    form = TranslationForm( request.POST if request.method == 'POST' else {} )
    if form.is_valid():
        # get the object and translate it
        translation = form.save(commit=False)
        translation.translate()
        # populate the form with the updated translation
        form = TranslationForm(translation)
    return render(request, 'translate/translate.html', {'form': form })

