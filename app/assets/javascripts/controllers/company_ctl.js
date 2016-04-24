angular.module('app').controller('CompanyCtl', ["$scope", "$http",
  function($scope, $http) {
    'use strict';

    $scope.init = function() {
        $http.post('/graphql/', {
          query: "{ company(id: 4) { id, name, customers  { name,  address { city } }}}"
        }).then(function(res){
          $scope.customers = res.data.data.company.customers
        }, function(res){

        });
    };
}]);
