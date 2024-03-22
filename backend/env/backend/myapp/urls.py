from django.urls import path
from . import views 
urlpatterns = [
    path('products/', views.create_product, name='products'),
    path('all-products/', views.get_all_products, name='get_all_products'),
    path('products/<int:product_id>/', views.delete_product, name='delete_product'),

    
]
