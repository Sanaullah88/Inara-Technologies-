from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .models import Product
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt



@api_view(['POST'])
def create_product(request):
    if request.method == 'POST':
        name = request.data.get('name')
        description = request.data.get('description')
        print(name)
        print(description)
        if not name or not description:
            return Response({"error": "Name and description are required"}, status=status.HTTP_400_BAD_REQUEST)
        product = Product.objects.create(name=name, description=description)
        return Response({"success": "Product created successfully"}, status=status.HTTP_201_CREATED)
    else:
        return Response({"error": "Method not allowed"}, status=status.HTTP_405_METHOD_NOT_ALLOWED)



@csrf_exempt
def get_all_products(request):
    products = Product.objects.all()
    product_data = [{'id': product.id, 'name': product.name, 'description': product.description} for product in products]
    return JsonResponse({'products': product_data}, safe=False)



@csrf_exempt
def delete_product(request, product_id):
    if request.method == 'DELETE':
        try:
            product = Product.objects.get(pk=product_id)
            product.delete()
            return JsonResponse({'message': 'Product deleted successfully'}, status=204)
        except Product.DoesNotExist:
            return JsonResponse({'error': 'Product not found'}, status=404)
    else:
        return JsonResponse({'error': 'Method not allowed'}, status=405)
