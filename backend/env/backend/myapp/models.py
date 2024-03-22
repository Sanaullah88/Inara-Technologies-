from django.db import models

class Product(models.Model):
    id= models.IntegerField(primary_key=True)
    name = models.CharField(max_length=100)
    description = models.TextField()

    def __str__(self):
        return self.name
