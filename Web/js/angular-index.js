//angular-index.js
var module = angular.module("angularIndex", []);

module.config(function ($routeProvider) {
    $routeProvider.when("/useraccounts", {
        controller: "userAccountsController",
        templateUrl: "/templates/userAccountsView.html"
    });

    $routeProvider.when("/newmessage", {
        controller: "newTopicController",
        templateUrl: "/templates/newTopicView.html"
    });

    $routeProvider.when("/message/:id", {
        controller: "singleTopicController",
        templateUrl: "/templates/singleTopicView.html"
    });

    $routeProvider.otherwise({ redirectTo: "/" });
});
module.factory("dataService", function($http, $q) {
    var _userAccounts = [];
    var _isInit = false;

    var _isReady = function() {
        return _isInit;
    };
    var _getUserAccounts = function() {

        var deferred = $q.defer();

        $http.get("/api/useraccounts")
            .then(function(result) {
                //Success
                angular.copy(result, _userAccounts);
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

    function _findTopic(id) {
        var found = null;

        $.each(_topics, function(i, item) {
            if (item.id == id) {
                found = item;
                return false; 
            }
        });

        return found;
    }

    var _getTopicById = function(id) {
        var deferred = $q.defer();

        if (_isReady()) {
            var topic = _findTopic(id);
            if (topic) {
                deferred.resolve(topic);
            } else {
                deferred.reject();
            }
        } else {
            $http.get("/api/", id)
                .then(function(result) {
                    //success
                    if (topic) {
                        deferred.resolve(topic);
                    } else {
                        deferred.reject();
                    }
                }, function() {
                    //error
                deferred.reject();
            });
        }

        return deferred.promise;
    };

    var _saveReply = function(topic,newReply) {
        var deferred = $q.defer();

        $http.post("api/")
            .then(function(result) {
                //success
            if (topic.replies == null) topic.replies = [];
            topic.replies.push(result.data);
            deferred.resolve(result.data);
        }, function() {
            //error]
            deferred.reject(); 
        });

        return deferred.promise;
    }

    return {
        userAccounts: _userAccounts,
        getUserAccounts: _getUserAccounts,
        addTopic: _addTopic,
        isReady: _isReady,
        getTopicById: _getTopicById,
        saveReply: _saveReply
    };
});

function angularIndexController($scope) {
    $scope.greeting = "Hello World!";
}

function userAccountsController($scope, $http, dataService) {
    $scope.dataCount = 0;
    $scope.data = [];
    $scope.isBusy = false;

    if (dataService.isReady() == false) {
        $scope.isBusy = true;
        dataService.getUserAccounts()
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

function singleTopicController($scope, dataService, $window, $routeParams) {
    $scope.topics = null;
    $scope.newReply = {};

    dataService.getTopicById($routeParams.id)
        .then(function(topic) {
            //Success
            $scope.topic = topic;
        }, function() {
            //Error
            $window.location = "#/";
        });

    $scope.addReply = function() {
        dataService.saveReply($scope.topic, $scope.newReply)
            .then(function() {
                //success
            $scope.newReply.body = "";
        }, function() {
                //error
            alert("Could not save the new reply");
        });
    };
}