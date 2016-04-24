# GraphQL - a new era in distributed computing
Before the invention of the web, if we wanted to build an application that communicates with other application, it was very complicated. We needed to read long documents such as ICD (interface control document) or other communication protocols and develop the interface layer our own. If the other application was written in other language it was even harder, sometimes the best solution was to get a library of the code and include it in our project.
 After the invention of the web, it was decided that there should be a better way, and we should have a standard way to perform this communication without the tight engagement. HTTP and XML was mature enough and ‘web services’ were invented.

The main idea behind web services is that it publishes a contract (WSDL - web service description language) that describe all its data types and methods. The consumer reads the WSDL (there were good tooling for it) and learn how to activate it. The protocol behind it was SOAP (Simple Object Access Protocol). It was widely spread for some years until a lot of developers found this method very cumbersome. It was too verbose, and consume a lot of bandwidth.

Its successor was REST (representational state transfer) with JSON (JavaScript object notation). REST uses HTTP commands (mainly get, post, put and delete) and it receives and send messages as in JSON format. It is a lot simpler and loosely coupled. The name had been changed from Web-Service to Web API (or Restful API).
One of the most popular ways to use REST, is to send JSON from the server to the client and then render it using JavaScript. REST is perfect for this mission. But it has one problem,it sends the whole object (or list of objects). This is the common practice, because we do not know what is going to be rendered on the client. For example, if we wanted to display list of company’s customers (partial data of each customer) with some data about the company, we needed to fetch the company object and then all its customers (1 + N problem). The result is waste of bandwidth and performance.
GraphQL comes to solve it.

## GraphQL
[GraphQL](http://graphql.org/) was created in Facebook in 2012. It was used internally for few years and released as open source last year (2015).
GraphQL is a data query language and runtime designed to request and deliver data to mobile and web apps.
GraphQL query describes in the request, the data it would like to receive. Instead of returning the whole object or list, the returned value will be only the requested data. It means less bandwidth and less performance of parsing the returned data.
Although its name resembles SQL (Structured Query Language - Language for database queries), GraphQL is not intended to be use directly with the database but rather against the application server. Meaning that the server needs to fetch the data from the database (all the data or only part of it, depends on the implementation), and serve it partially to the client.
In the example above, the server will fetch the company object and all its customers, but will serve only a partial part of the data according to the request.

GraphQL is a protocol, and not an implementation. Facebook offers their implementation but the sense is that the community will develop more implementations to any environment or programming language.

## GraphQL principles
- __Hierarchical__: support Hierarchical structure.
- __Client-specified queries__: queries are encoded in the client rather than the server.
- __Backwards Compatible__: because the queries are encoded in the client, it is very easy to support older versions of clients (native apps) as long as the server still support all historical fields.
- __Application-Layer Protocol__: GraphQL is an application-layer protocol and does not require a particular transport. It is a string that is parsed and interpreted by a server.
- __Strongly-typed__: Given a query, tooling can ensure that the query is both syntactically correct and valid within the GraphQL type system before execution
- __Introspective__: Clients and tools can query the type system using the GraphQL syntax itself.

[Here](http://graphql.org/) is the full list.
## GraphQL structure
Request:
```
  company(id: "123") {
    id,
    name,
    address,
    customers {
      id,
      name,
      email
    }
  }
```


And the response will be (JSON format):
``` JavaScript
{
  "company" : {
    "id": 123,
    "name": "BestCompany",
    "address": “270 Park Avenue NY”,
    "customers ": [
     {"id": 1,
      "name": "Jack Brown",
      "email": “Jack@brown.com”},
     {"id": 2,
        "name": "Mark Blue",
        "email": “Mark@brBlueown.com”}
        }
      }
```
As you can see, the request defines the data it needs, and the response contains only it without extra data.
## GraphQL in practice with Rails and Angular
Angular?!?  The reason that i decided to show this example with angular and Rails,  is to separate GraphQL from the other Facebook’s libraries. Although the main usage of GraphQL is with React and Relay. You can implement it with any framework.
The application will show for each company, the cities where their customer lives.
We will start by creating a regular rails project:
```
Rails new MyCustomers
cd MyCustomers
```

Then we will add to the Gemfile:
``` ruby
gem ‘graphql’
```
In this example i will use Angular and bootstrap, I installed them By Bower.
The next thing is to create the server side. I will create 3 models:
Company, Customer and Address
```
rails g model company name:string
rails g model customer name:string email:string company_id:integer
rails g model address city:string street:name num:integer, customer_id:integer
```
Next  i will add all the graphql items:
Graphql types:
 - Company_type

``` ruby
CompanyType = GraphQL::ObjectType.define do
  name "Company"
  description "A Company"

  # Expose fields associated with Company model
  field :id, types.ID, "This id of this company"
  field :name, types.String, "The name of the company"
  field :customers, types[CustomerType]

end
```
CompanyType inherites the GraphQL::ObjectType.
It has a name, description, and a set of fields, that it exposes.
Each field has its name, its type, and a description (all descriptions are used for the schema definition - to work with types in the client side).
 - Customer_type

``` ruby
CustomerType = GraphQL::ObjectType.define do
  name "Customer"
  description "A customer of a company"

  # Expose fields associated with Customer model
  field :id, types.ID, "This id of this customer"
  field :name, types.String, "The name of the customer"
  field :email, types.String, "The email of the customer"
  field :company_id, types.ID, "The customer's company"
  field :address, AddressType
end
```

 - address_type

``` ruby
AddressType = GraphQL::ObjectType.define do
  name "Address"
  description "A customer address"

  # Expose fields associated with Address model
  field :id, types.ID, "This id of this address"
  field :city, types.String, "City"
  field :street, types.String, "Street"
  field :num, types.String, "House number"
end

```
Next I will create the root query for GraphQL:

``` ruby
QueryType = GraphQL::ObjectType.define do
  name "Query"
  description "The query root of this schema. See available queries."

  field :company, CompanyType do
    argument :id, !types.ID
    description 'Root object to get viewer related collections'
    resolve -> (obj, args, ctx) {
      Company.find(args["id"])
    }
  end

  field :companies, types[CompanyType] do
  description 'Root object to get viewer related collections'
    resolve -> (obj, args, ctx) {
      Company.all
    }
  end
end
```
I defined two queries:
- Company - which will return the company (by id) as root object
- Companies - returns all companies

In order to use the query, i will define the schema object:

``` ruby
CompanySchema = GraphQL::Schema.new(query: QueryType )
```
We need to add include this path in the application.rb:

``` ruby
config.autoload_paths << Rails.root.join('app/graph/types')
```

Now I can create my controller and start using my GraphQL schema:

``` ruby
class CompanyController < ApplicationController
  def graphql
    query = GraphqlSchema.execute(params[:query])
    render json: query
  end

  def index
  end
end
```
The controller will have two endpoints:
- Index - used for our SPA
- graphql - single endpoint for all the communication. This is the prefered way - make one endpoint for all the communication, instead of one per call.

I added those endpoints in the routes.db.
I added some data using Faker. Lets try it out:

```
curl -X POST -d "query={companies {name}}" http://localhost:3000/graphql
```

We got:

``` JavaScript
{"data":
  {"companies":[
    {"name":"Leffler, Wiza and Weissnat"},
    {"name":"Blanda, Walker and Schiller"},
    {"name":"Lubowitz, Klocko and Walter"},
    {"name":"Kohler Group"},
    {"name":"Kassulke and Sons"}
  ]}}
```

Lets try the second query:

```
curl -X POST -d "query={ company(id: 4) {id, name, customers {name, address {city}}}}" http://localhost:3000/graphql
```
And the returned value is:

```JavaScript
{"data":
  {"company":
    {"id":"4","name":"Lubowitz, Klocko and Walter",
    "customers":
      [{"name":"Immanuel Upton",
      "address":
        {"city":"New Mosesmouth"}},
      {"name":"Blanche Terry",
      "address":{
        "city":"Lake Fionachester"}},
      {"name":"Miss Eldora Hauck",
      "address":{"city":"Croninbury"}}
  ]}}}
```
Great!
Now it is time to consume this service from our angular app:
Html:
``` html
<div class="container">
    <h1>Our Customers lives in:</h1>
    <div>
        <article ng-app="app">
          <div ng-controller="CompanyCtl" ng-init="init()">
            <select ng-change="update()" ng-options="company.name  for company in companies" ng-model="selected"></select>
            <ul>
              <li ng-repeat="customer in customers">
                {{customer.address.city}}
              </li>
            </ul>
          </div>
        </article>
    </div>
</div>
```
Controller:
``` javascript
angular.module('app').controller('CompanyCtl', ["$scope", "$http",
  function($scope, $http) {
    'use strict';

    $scope.init = function() {
        $http.post('/graphql/', {
          query: "{companies { id, name } }"
        }).then(function(res) {
          $scope.companies = res.data.data.companies;
        }, function(res){
            alert("error!")
        })
    };

    $scope.update = function(){
      $http.post('/graphql/', {
        query: "{ company(id: "+ $scope.selected.id + ") { id, name, customers  { name,  address { city } }}}"
      }).then(function(res){
        $scope.customers = res.data.data.company.customers
      }, function(res){
        alert("error!")
      });
    };
}]);
```
So simple!
Now if we want to build a new page for our application, we have to write our query without changing our server. For instance, to get the list of email:
``` javascript
query={ company(id: 4) {id, name, customers {email}}}
```
We will get:
```JavaScript
{
    "data": {
        "company": {
            "customers": [
                {
                    "email": "nicolette.borer@bergnaum.co"
                },
                {
                    "email": "roscoe_vonrueden@lowe.name"
                },
                {
                    "email": "madaline@predovic.name"
                },
            ],
            "id": "4",
            "name": "Lubowitz, Klocko and Walter"
        }
    }
}
```

## Conclusion
GraphQL is a new way to communicate between computers, and especially between client and server.
It simplify the communication and allows the client to specify its query without handling data it doesn’t need. There is  a lot more to it like mutation (create and update records), cached queries, visual tool for the client that is based on the schema [graphiQL](https://github.com/graphql/graphiql) - just like the old WSDL (the history repeats itself!). The best parctice today is to combine it with [Relay](https://facebook.github.io/relay) and React. There is a [Gem](https://github.com/rmosolgo/graphql-relay-ruby) that abstract the use of it.

### Useful references:
- https://github.com/rmosolgo/graphql-ruby
- https://blog.jacobwgillespie.com/from-rest-to-graphql-b4e95e94c26b#.skleyq1bm
- http://www.startuplandia.io/posts/rails-react-relay-graphql-tutorial-queries/
