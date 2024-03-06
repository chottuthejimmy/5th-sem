angular.module('bookstoreApp', [])
.controller('BookstoreController', function($http) {
    var store = this;
    store.name = 'The Internet Bookshop';
    store.books = [];

    // Fetch books from database
    $http.get('get_books.php')
    .then(function(response) {
        store.books = response.data;
    })
    .catch(function(error) {
        console.error('Error fetching books:', error);
    });

    store.cart = [];

    store.addToCart = function(book) {
        var bookInCart = store.cart.find(function(cartBook) {
            return cartBook.id === book.id;
        });

        if (!bookInCart) {
            store.cart.push(book);
        } else {
            alert(book.title + ' is already in the cart.');
        }
    };

    store.getTotalAmount = function() {
        return store.cart.reduce(function(total, book) {
            return total + book.price;
        }, 0);
    };

    store.removeFromCart = function(index) {
        store.cart.splice(index, 1);
    };

    store.checkout = function() {
        $http.post('checkout.php', { cart: store.cart })
        .then(function(response) {
            console.log('Checkout response:', response.data);
            if (response.data.success) {
                // Clear cart or redirect to order confirmation page
                store.cart = [];
                alert('Checkout successful!');
            } else {
                alert('Error during checkout: ' + response.data.message);
            }
        })
        .catch(function(error) {
            console.error('Error during checkout:', error);
            alert('Error during checkout, please try again.');
        });
    };
});
