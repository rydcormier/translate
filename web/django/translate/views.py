from django.shortcuts import render

from .forms import TranslationForm

def translate(request):
    form = TranslationForm( request.POST if request.method == 'POST' else {} )
    if form.is_valid():
        translation = form.save(commit=False)
        translation.translate()
        form = TranslationForm(translation)
    return render(request, 'translate/translate.html', {'form': form })

