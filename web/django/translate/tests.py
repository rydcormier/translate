# translate/test.py
from django.test import TestCase

from .forms import TranslationForm
from .models import Translation

def gen_data(source='auto', target='fr', input='Hello, world!'):
    return { 'source': source, 'target': target, 'input': input }

class TranslationModelTests(TestCase):

    def test_translate(self):
        """test_translation() checks that the translation is fetched and
        set correctly.
        """
        translation = Translation(**gen_data())
        translation.translate()
        self.assertEqual('Bonjour le monde!', translation.output)

    def test_translate_with_translit(self):
        """test_translate_with_translit() checks that a transliteration
        is fetched if it exists.
        """
        translation = Translation(**gen_data(target='zh-cn'))
        translation.translate()
        self.assertRegex(translation.output, 'Nǐ hǎo.* shìjiè')


class TranslationFormTests(TestCase):

    def test_choice_fields(self):
        """text_choice_fields() verifies that 'auto' is a 'source' choice
        but not a 'target' choice.
        """
        form = TranslationForm()
        self.assertIn(('auto', 'detect language'), form.fields['source'].choices)
        self.assertNotIn(('auto', 'detect language'), form.fields['target'].choices)

    def test_validation(self):
        """test_validation() checks that the form is validated correctly."""
        data = gen_data()
        form = TranslationForm(data)
        self.assertTrue(form.is_valid())
        data = gen_data(source='jibberish')
        form = TranslationForm(data)
        self.assertFalse(form.is_valid())
        data = gen_data(input='')
        form = TranslationForm(data)
        self.assertFalse(form.is_valid())

    def test_init_with_translation(self):
        """test_validation_with_translation() tests initialization given an
        instance of the target model.
        """
        data = gen_data()
        data['output'] = 'Bonjour le monde!'
        form = TranslationForm(data)
        self.assertTrue(form.is_valid())
        self.assertEqual(form.cleaned_data['output'], data['output'])


class TranslateViewTests(TestCase):

    def test_get_request(self):
        """test_get_request() checks that a get request returns a new form."""
        response = self.client.get('/translate/')
        form = response.context.get('form')
        self.assertIsNotNone(form)
        self.assertFalse(form.is_valid())

    def test_bad_post_request(self):
        """test_bad_post_request() verifies that given invalid post data, the
        view returns with an error message.
        """
        data = gen_data(input='')
        response = self.client.post('/translate/', data)
        form = response.context.get('form')
        self.assertIsNotNone(form)
        self.assertIsNotNone(form.errors['input'])

    def test_good_post_request(self):
        """test_good_post_request() checks that a good post request returns
        a form populated with the post data and that the form's output field
        is correct.
        """
        data = gen_data()
        response = self.client.post('/translate/', data)
        form = response.context.get('form')
        self.assertIsNotNone(form)
        self.assertTrue(form.is_valid())
        for key in ('source', 'target', 'input'):
            self.assertEqual(form.cleaned_data[key], data[key])
        self.assertEqual('Bonjour le monde!', form.cleaned_data['output'])

