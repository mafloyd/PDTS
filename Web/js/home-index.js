﻿//home-index.js
var module = angular.module("homeIndex", []);

module.config(function($routeProvider) {
    $routeProvider.when("/", {
        controller: "topicsController",
        templateUrl: "/templates/topicsView.html"
    });

    $routeProvider.when("/newmessage", {
        controller: "newTopicController",
        templateUrl: "/templates/newTopicView.html"
    });

    $routeProvider.otherwise({ redirectTo: "/" });
});
module.factory("dataService", function($http, $q) {
    var _topics = [];
    var _isInit = false;

    var _isReady = function() {
        return _isInit;
    };
    var _getTopics = function() {

        var deferred = $q.defer();

        $http.get("/api/")
            .then(function(result) {
                //Success
                angular.copy(result, _topics);
                _isInit = true;
                $scope.dataCount = result.data.length;
                deferred.resolve(); //Can return data optionally here as an argument
            }, function() {
                //Error
                deferred.reject();
            })
            .then(function() {
                $scope.isBusy = false;
            });

        return deferred.promise;
    };

    var _addTopic = function(newTopic) {
        var deferred = $q.defer();

        //Persist to WebAPI
        $http.post("/api/", newTopic)
            .then(function(result) {
                //success
                var newlyCreatedTopic = result.data;
                _topics.splice(0, 0, newlyCreatedTopic);
                deferred.resolve(newlyCreatedTopic);
            }, function() {
                //failure
                deferred.reject();
            });

        return deferred.promise;
    };

    return {
        topics: _topics,
        getTopics: _getTopics,
        addTopic: _addTopic,
        isReady: _isReady
    };
});

function topicsController($scope, $http, dataService) {
    $scope.dataCount = 0;
    $scope.data = [];
    $scope.isBusy = false;

    if (dataService.isReady() == false) {
        $scope.isBusy = true;
        dataService.getTopics()
            .then(function() {
                //Success
            }, function() {
                //Error
                alert("Could not load topics");
            })
            .then(function() {
                $scope.isBusy = false;
            });
    }
}

function newTopicController($scope, $http, $window, dataService) {
    $scope.newTopic = {};

    $scope.save = function() {
        dataService.addTopic($scope.newTopic)
            .then(function() {
                //Success
            }, function() {
                //Failure
                alert("Could not save the new topic");
            });
    };
}