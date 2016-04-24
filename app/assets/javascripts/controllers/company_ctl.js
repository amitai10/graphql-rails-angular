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
