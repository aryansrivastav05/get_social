from django.test import TestCase
from django.urls import reverse
from django.contrib.auth.models import User
from .models import Post


class BasicViewsTest(TestCase):
    def setUp(self):
        # create a user and a sample post
        self.user = User.objects.create_user(username='tester', email='t@example.com', password='pass')
        self.post = Post.objects.create(user=self.user, text='sample text')

    def test_home_renders(self):
        resp = self.client.get(reverse('post_list'))
        self.assertEqual(resp.status_code, 200)

    def test_login_page_renders(self):
        resp = self.client.get(reverse('login'))
        # should return 200 and use the login template
        self.assertEqual(resp.status_code, 200)

    def test_create_requires_login(self):
        resp = self.client.get(reverse('post_create'))
        # unauthenticated should be redirected to login
        self.assertIn(resp.status_code, (302,))

    def test_create_allowed_for_logged_in(self):
        self.client.login(username='tester', password='pass')
        resp = self.client.get(reverse('post_create'))
        self.assertEqual(resp.status_code, 200)
