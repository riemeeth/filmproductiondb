import os
from flask import Flask, render_template, redirect, request
from database.db_connector import connection


app = Flask(__name__, static_folder='static', template_folder='templates')


# routes
@ app.route('/')
def root():
    return render_template('index.j2')


@ app.route('/productions/delete/<int:id>')
def delete_production(id):
    query = "DELETE FROM Productions WHERE productionID = %s;"
    conn = connection()
    cursor = conn.cursor()
    cursor.execute(query, (id))
    conn.commit()
    cursor.close()
    conn.close()
    return redirect('/productions')


@ app.route('/orders', methods=['GET', 'POST'])
def orders():
    if request.method == 'GET':
        query = "SELECT DISTINCT(orders.orderid) as 'Order ID', studios.studioName as Studio, productions.showName as Production, termscodes.termName as Terms, salesreps.salesRepName as 'Sales Rep', orderDate as 'Order Date', purchaseOrder as 'Purchase Order', (SELECT SUM(totalAmount) FROM OrderDetails WHERE orders.orderid = orderdetails.orderid) as 'Total Invoice Amount' FROM Orders INNER JOIN orderdetails ON orders.orderid = orderdetails.orderid INNER JOIN productions ON orders.productionid = productions.productionid INNER JOIN salesreps ON orders.salesrepid = salesreps.salesrepid INNER JOIN termscodes ON termscodes.termscodeid = orders.termscodeid LEFT JOIN studios ON studios.studioID = productions.studioID GROUP BY orders.orderid ORDER BY orders.orderid ASC;"
        query2 = "SELECT showName, productionID FROM Productions;"
        query3 = "SELECT salesRepName, salesRepID FROM SalesReps;"
        query4 = "SELECT termName, termscodeid FROM TermsCodes;"
        query5 = "SELECT productID, productName FROM Products;"
        conn = connection()
        cursor = conn.cursor()
        cursor.execute(query)
        results = cursor.fetchall()
        cursor.execute(query2)
        results_prod = cursor.fetchall()
        cursor.execute(query3)
        results_salesrep = cursor.fetchall()
        cursor.execute(query4)
        results_terms = cursor.fetchall()
        cursor.execute(query5)
        results_products = cursor.fetchall()
        cursor.close()
        conn.close()
        return render_template('orders.j2', orders=results, productions=results_prod, salesreps=results_salesrep, terms=results_terms, products=results_products)
    elif request.method == 'POST':
        query = "INSERT INTO Orders (productionid, salesrepid, termscodeid, orderDate, purchaseOrder) VALUES (%s, %s, %s, %s, %s);"
        query2 = "INSERT INTO OrderDetails (orderid, productid, orderQty, unitPrice, totalAmount) VALUES (%s, %s, %s, %s, %s);"
        conn = connection()
        cursor = conn.cursor()
        cursor.execute(query, (request.form['production'], request.form['salesrep'],
                               request.form['term'], request.form['inputDate'], request.form['inputPO']))
        order_id = cursor.lastrowid
        cursor.execute(query2, (order_id, request.form['product'],
                                request.form['inputQuantity'], request.form['inputPrice'], str(int(request.form['inputQuantity']) * int(request.form['inputPrice']))))  # totalAmount INSERT is calculated here, cast string->int->string
        # since one item is required, ^^ this function line 58 always executes ^^
        # if there are multiple items:
        # loop through 'add item rows' on create form, concatenating the div names with incrementing counter to get the values, starting 1
        # the JS function on the create form will create the div with names corresponding to the counter, i.e. 'product1', 'product2', etc.
        # when it hits last row + 1, it will throw an error because it will try to get the values of a non-existent div
        # exception is handled by catching the general exception and ignoring it. Instead commit the query, close the connection, and redirect to the orders page
        # this is a hacky way to do it, but it works
        try:
            counter = 1
            while True:
                cursor.execute(query2, (order_id, request.form['product' + str(counter)],
                                        request.form['inputQuantity' + str(counter)], request.form['inputPrice' + str(counter)], str(int(request.form['inputQuantity' + str(counter)]) * int(request.form['inputPrice' + str(counter)]))))
                counter += 1
        except Exception:
            conn.commit()
            cursor.close()
            conn.close()
            return redirect('/orders')


@ app.route('/orders/production', methods=['GET'])
def order_production():
    args = request.args.get('production')
    query = "SELECT DISTINCT(orders.orderid) as 'Order ID', studios.studioName as Studio, productions.showName as Production, termscodes.termName as Terms, salesreps.salesRepName as 'Sales Rep', orderDate as 'Order Date', purchaseOrder as 'Purchase Number', (SELECT SUM(totalAmount) FROM OrderDetails WHERE orders.orderid = orderdetails.orderid) as 'Total Invoice Amount' FROM orders INNER JOIN orderdetails ON orders.orderid = orderdetails.orderid INNER JOIN productions ON orders.productionid = productions.productionid INNER JOIN salesreps ON orders.salesrepid = salesreps.salesrepid INNER JOIN termscodes ON termscodes.termscodeid = orders.termscodeid LEFT JOIN studios ON studios.studioID = productions.studioID WHERE productions.productionid = %s GROUP BY orders.orderid;"
    conn = connection()
    cursor = conn.cursor()
    cursor.execute(query, (args))
    results = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('orders_productions.j2', productions=results)


@ app.route('/orders/invoice/<int:id>')
def order_invoice(id):
    query = "SELECT DISTINCT(orders.orderid) as 'Order ID', studios.studioName as Studio, productions.showName as Production, termscodes.termName as Terms, salesreps.salesRepName as 'Sales Rep', orderDate as 'Order Date', purchaseOrder as 'Purchase Order', (SELECT SUM(totalAmount) FROM orderdetails WHERE orders.orderid = orderdetails.orderid) as 'Total Invoice Amount' FROM Orders INNER JOIN orderdetails ON orders.orderid = orderdetails.orderid INNER JOIN productions ON orders.productionid = productions.productionid INNER JOIN salesreps ON orders.salesrepid = salesreps.salesrepid INNER JOIN termscodes ON termscodes.termscodeid = orders.termscodeid LEFT JOIN studios ON studios.studioID = productions.studioID WHERE orders.orderid = %s;"
    query2 = "SELECT DISTINCT(orderdetails.productID) as 'Product ID', products.productName as 'Product Name', orderQty as Quantity, unitPrice as 'Unit Price', totalAmount as 'Total Amount' FROM OrderDetails INNER JOIN products ON products.productID = orderdetails.productid WHERE orderid = %s;"
    conn = connection()
    cursor = conn.cursor()
    cursor.execute(query, (id))
    results = cursor.fetchall()
    cursor.execute(query2, (id))
    results_details = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('orders_invoice.j2', orders=results, orderdetails=results_details)

@ app.route('/orders/edit/<int:id>')
def edit_order(id):
        query = "SELECT DISTINCT(orders.orderid) as 'Order ID', studios.studioName as Studio, productions.showName as Production, termscodes.termName as Terms, salesreps.salesRepName as 'Sales Rep', orderDate as 'Order Date', purchaseOrder as 'Purchase Order', (SELECT SUM(totalAmount) FROM orderdetails WHERE orders.orderid = orderdetails.orderid) as 'Total Invoice Amount' FROM Orders INNER JOIN orderdetails ON orders.orderid = orderdetails.orderid INNER JOIN productions ON orders.productionid = productions.productionid INNER JOIN salesreps ON orders.salesrepid = salesreps.salesrepid INNER JOIN termscodes ON termscodes.termscodeid = orders.termscodeid LEFT JOIN studios ON studios.studioID = productions.studioID WHERE orders.orderid = %s;"
        query2 = "SELECT DISTINCT(orderdetails.productID) as 'Product ID', orderDetailsID as ID, products.productName as 'Product Name', orderQty as Quantity, unitPrice as 'Unit Price', totalAmount as 'Total Amount' FROM OrderDetails INNER JOIN products ON products.productID = orderdetails.productid WHERE orderid = %s;"
        conn = connection()
        cursor = conn.cursor()
        cursor.execute(query, (id))
        results = cursor.fetchall()
        cursor.execute(query2, (id))
        results_details = cursor.fetchall()
        cursor.close()
        conn.close()
        return render_template('orders_edit.j2', orders=results, orderdetails=results_details)


@ app.route('/orders/deleteproduct/<int:id>')
def delete_lineitem(id):
    query = "DELETE FROM OrderDetails WHERE orderDetailsID = %s;"
    conn = connection()
    cursor = conn.cursor()
    cursor.execute(query, (id))
    conn.commit()
    cursor.close()
    conn.close()
    return redirect('/orders')


@ app.route('/orders/delete/<int:id>')
def delete_studio(id):
    query = "DELETE FROM Orders WHERE orderID = %s;"
    conn = connection()
    cursor = conn.cursor()
    cursor.execute(query, (id))
    conn.commit()
    cursor.close()
    conn.close()
    return redirect('/orders')


@ app.route('/products', methods=['GET', 'POST'])
def products():
    if request.method == 'GET':
        getproducts = "SELECT ProductID as ID, productName as Name, cost as Cost, retailPrice as 'Retail Price', vendors.vendorName as Vendor FROM Products INNER JOIN vendors ON products.vendorid = vendors.vendorid ORDER BY productID ASC;"
        getvendornames = "SELECT vendorName, vendorID FROM Vendors;"
        conn = connection()
        cursor = conn.cursor()
        cursor.execute(getproducts)
        results = cursor.fetchall()
        cursor.execute(getvendornames)
        results_vendor = cursor.fetchall()
        cursor.close()
        conn.close()
        return render_template('products.j2', products=results, vendors=results_vendor)
    if request.method == 'POST':
        name = request.form['inputProductName']
        cost = request.form['inputCost']
        retailPrice = request.form['inputPrice']
        vendorID = request.form['inputVendor']
        query = "INSERT INTO Products (productName, cost, retailPrice, vendorID) VALUES (%s, %s, %s, %s);"
        conn = connection()
        cursor = conn.cursor()
        cursor.execute(query, (name, cost,
                       retailPrice, vendorID))
        conn.commit()
        cursor.close()
        conn.close()
        return redirect('/products')


@ app.route('/salesreps', methods=['GET', 'POST'])
def salesreps():
    if request.method == 'GET':
        query = "SELECT salesRepID as ID, salesRepName as Name, salesRepEmail as Email FROM SalesReps;"
        conn = connection()
        cursor = conn.cursor()
        cursor.execute(query)
        results = cursor.fetchall()
        cursor.close()
        conn.close()
        return render_template('salesreps.j2', salesreps=results)
    elif request.method == 'POST':
        salesRepName = request.form['inputName']
        salesRepEmail = request.form['inputEmail']
        query = "INSERT INTO SalesReps (salesRepName, salesRepEmail) VALUES (%s, %s);"
        conn = connection()
        cursor = conn.cursor()
        cursor.execute(query, (salesRepName, salesRepEmail))
        conn.commit()
        cursor.close()
        conn.close()
        return redirect('/salesreps')


@ app.route('/salesreps/edit/<int:id>', methods=['GET', 'POST'])
def edit_salesrep(id):
    if request.method == 'GET':
        getrep = "SELECT * FROM SalesReps WHERE salesRepID = %s;"
        conn = connection()
        cursor = conn.cursor()
        cursor.execute(getrep, (id))
        results = cursor.fetchone()
        cursor.close()
        conn.close()
        return render_template('salesreps_edit.j2', salesrep=results)
    elif request.method == 'POST':
        salesRepName = request.form['editName']
        salesRepEmail = request.form['editEmail']
        query = "UPDATE SalesReps SET salesRepName = %s, salesRepEmail = %s WHERE salesRepID = %s;"
        conn = connection()
        cursor = conn.cursor()
        cursor.execute(query, (salesRepName, salesRepEmail, id))
        conn.commit()
        cursor.close()
        conn.close()
        return redirect('/salesreps')


@ app.route('/studios', methods=['GET', 'POST'])
def studios():
    if request.method == 'GET':
        getstudios = "SELECT studioID as ID, studioName as Studio, contactName as 'Studio Contact', contactEmail as Email, addressLine1 as 'Address Line 1', addressLine2 as 'Address Line 2', city as City, state as State, zipCode as Zip FROM Studios;"
        conn = connection()
        cursor = conn.cursor()
        cursor.execute(getstudios)
        results = cursor.fetchall()
        cursor.close()
        conn.close()
        return render_template('studios.j2', studios=results)
    if request.method == 'POST':
        studioName = request.form['inputName']
        contactName = request.form['inputContact']
        contactEmail = request.form['inputEmail']
        addressLine1 = request.form['inputAddress']
        addressLine2 = request.form['inputAddress2']
        city = request.form['inputCity']
        state = request.form['inputState']
        zipCode = request.form['inputZip']
        query = "INSERT INTO Studios (studioName, contactName, contactEmail, addressLine1, addressLine2, city, state, zipCode) VALUES (%s, %s, %s, %s, %s, %s, %s, %s);"
        conn = connection()
        cursor = conn.cursor()
        cursor.execute(query, (studioName, contactName, contactEmail,
                       addressLine1, addressLine2, city, state, zipCode))
        conn.commit()
        cursor.close()
        conn.close()
        return redirect('/studios')


@ app.route('/studios/delete/<int:id>')
def delete_studio(id):
    query = "DELETE FROM Studios WHERE studioID = %s;"
    conn = connection()
    cursor = conn.cursor()
    cursor.execute(query, (id))
    conn.commit()
    cursor.close()
    conn.close()
    return redirect('/studios')


@ app.route('/studios/edit/<int:id>', methods=['GET', 'POST'])
def edit_studio(id):
    if request.method == 'GET':
        query = "SELECT * FROM Studios WHERE studioID = %s;"
        conn = connection()
        cursor = conn.cursor()
        cursor.execute(query, (id))
        results = cursor.fetchone()
        cursor.close()
        conn.close()
        return render_template('studios_edit.j2', studio=results)
    if request.method == 'POST':
        studioName = request.form['editName']
        contactName = request.form['editContact']
        contactEmail = request.form['editEmail']
        addressLine1 = request.form['editAddress']
        addressLine2 = request.form['editAddress2']
        city = request.form['editCity']
        state = request.form['editState']
        zipCode = request.form['editZip']
        query = "UPDATE Studios SET studioName = %s, contactName = %s, contactEmail = %s, addressLine1 = %s, addressLine2 = %s, city = %s, state = %s, zipCode = %s WHERE studioID = %s;"
        conn = connection()
        cursor = conn.cursor()
        cursor.execute(query, (studioName, contactName, contactEmail,
                               addressLine1, addressLine2, city, state, zipCode, id))
        conn.commit()
        cursor.close()
        conn.close()
        return redirect('/studios')


@ app.route('/studios/productions/', methods=['GET'])
def studio_productions():
    if request.method == 'GET':
        args = request.args.get('studio')
        query = "SELECT productionID as ID, studios.studioName as Studio, showName as 'Show Name', productions.contactName as 'Production Contact', productions.contactEmail as Email, productions.addressLine1 as 'Address Line 1', productions.addressLine2 as 'Address Line 2', productions.city as City, productions.state as State, productions.zipCode as Zip FROM Productions INNER JOIN studios ON studios.studioID = productions.studioID WHERE productions.studioID = %s;"
        conn = connection()
        cursor = conn.cursor()
        cursor.execute(query, (args))
        results = cursor.fetchall()
        cursor.close()
        conn.close()
        return render_template('studios_productions.j2', productions=results)


@ app.route('/vendors', methods=['GET', 'POST'])
def vendors():
    if request.method == 'GET':
        query = "SELECT vendorID as ID, vendorName as Vendor, contactName as 'Vendor Contact', contactEmail as Email, addressLine1 as 'Address Line 1', addressLine2 as 'Address Line 2', city as City, state as State, zipCode as Zip FROM Vendors;"
        conn = connection()
        cursor = conn.cursor()
        cursor.execute(query)
        results = cursor.fetchall()
        cursor.close()
        conn.close()
        return render_template('vendors.j2', vendors=results)
    if request.method == 'POST':
        vendorName = request.form['inputName']
        contactName = request.form['inputContact']
        contactEmail = request.form['inputEmail']
        addressLine1 = request.form['inputAddress']
        addressLine2 = request.form['inputAddress2']
        city = request.form['inputCity']
        state = request.form['inputState']
        zipCode = request.form['inputZip']
        query = "INSERT INTO Vendors (vendorName, contactName, contactEmail, addressLine1, addressLine2, city, state, zipCode) VALUES (%s, %s, %s, %s, %s, %s, %s, %s);"
        conn = connection()
        cursor = conn.cursor()
        cursor.execute(query, (vendorName, contactName, contactEmail,
                       addressLine1, addressLine2, city, state, zipCode))
        conn.commit()
        cursor.close()
        conn.close()
        return redirect('/vendors')


@app.route('/vendors/products/', methods=['GET'])
def vendor_products():
    if request.method == 'GET':
        args = request.args.get('vendor')
        query = "SELECT productID as ID, vendors.vendorName as Vendor, productName as 'Product Name', cost as Cost, retailPrice as 'Retail Price' FROM Products INNER JOIN vendors ON vendors.vendorID = products.vendorID WHERE products.vendorID = %s;"
        conn = connection()
        cursor = conn.cursor()
        cursor.execute(query, (args))
        results = cursor.fetchall()
        cursor.close()
        conn.close()
        return render_template('vendors_products.j2', products=results)


@ app.route('/termscodes', methods=['GET', 'POST'])
def termscode():
    if request.method == 'GET':
        query = "SELECT termsCodeID as ID, termCode as Code, termName as Name FROM TermsCodes;"
        conn = connection()
        cursor = conn.cursor()
        cursor.execute(query)
        results = cursor.fetchall()
        cursor.close()
        conn.close()
        return render_template('termscodes.j2', termscodes=results)
    elif request.method == 'POST':
        termCode = request.form['inputCode']
        termName = request.form['inputName']
        query = "INSERT INTO TermsCodes (termCode, termName) VALUES (%s, %s);"
        conn = connection()
        cursor = conn.cursor()
        cursor.execute(query, (termCode, termName))
        conn.commit()
        cursor.close()
        conn.close()
        return redirect('/termscodes')


# Listener on port 5000
if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(port=port, debug=True)
