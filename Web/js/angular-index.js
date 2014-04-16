//angular-index.js
var module = angular.module("angularIndex", ["ngRoute"]);

module.config(function($routeProvider) {
    $routeProvider.when("/", {
        controller: "",
        templateUrl: "/templates/defaultView.html"
    });

    $routeProvider.when("/searchuseraccounts", {
        controller: "searchUserAccountsController",
        templateUrl: "/templates/searchUserAccountsView.html"
    });

    $routeProvider.when("/edituseraccount/:id", {
        controller: "editUserAccountController",
        templateUrl: "/templates/editUserAccountView.html"
    });

    $routeProvider.when("/message/:id", {
        controller: "singleTopicController",
        templateUrl: "/templates/singleTopicView.html"
    });

    $routeProvider.otherwise({ redirectTo: "/" });
});
module.factory("dataService", function($http, $q) {
    var userAccounts = [];
    var isInit = false;

    var isReady = function() {
        return isInit;
    };
    var getUserAccounts = function() {

        var deferred = $q.defer();

        $http.get("/api/useraccounts")
            .then(function(result) {
                //Success
                angular.copy(result.data, userAccounts);
                isInit = true;
                deferred.resolve(result);
            }, function() {
                //Error
                deferred.reject();
            });

        return deferred.promise;
    };

    var assignToAdGroup = function(userAccount) {
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

    function findUserAccount(id) {
        var found = null;

        $.each(userAccounts, function(i, item) {
            if (item.id == id) {
                found = item;
                return false;
            }
        });

        return found;
    }

    var getUserAccountById = function(id) {
        var deferred = $q.defer();

        if (isReady()) {
            var userAccount = findUserAccount(id);
            if (userAccount) {
                deferred.resolve(userAccount);
            } else {
                deferred.reject();
            }
        } else {
            $http.get("/api/", id)
                .then(function(result) {
                    //success
                    if (result.userAccount) {
                        deferred.resolve(result.userAccount);
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

    return {
        userAccounts: userAccounts,
        getUserAccounts: getUserAccounts,
        assignToAdGroup: assignToAdGroup,
        isReady: isReady,
        getUserAccountById: getUserAccountById
    };
});

function searchUserAccountsController($scope, $http, dataService) {
    $scope.dataCount = 0;
    $scope.data = dataService;
    $scope.isBusy = false;

    if (dataService.isReady() == false) {
        $scope.isBusy = true;
        dataService.getUserAccounts()
            .then(function(results) {
                //Success
                $scope.dataCount = results.data.length;
            }, function() {
                //Error
                alert("Could not load topics");
            })
            .then(function() {
                $scope.isBusy = false;
            });
    }
}

function getUserAccountByIdController($scope, $window, $routeParams, dataService) {
    dataService.getTopicById($routeParams.id)
        .then(function(topic) {
            //Success
            $scope.topic = topic;
        }, function() {
            //Error
            $window.location = "#/";
        });
}

function editUserAccountController($scope, dataService, $window, $routeParams) {
    $scope.userAccount = {};
    $scope.userId = $routeParams.id;

    //TODO: Disabled until WebAPI controller Put method is built
//    getUserById($routeParams.id);

    $scope.save = function() {
        dataService.assignToAdGroup($scope.newTopic)
            .then(function() {
                //Success
            }, function() {
                //Failure
                alert("Could not assign the user successfully");
            });
    };

    function getUserById(userId) {
        dataService.getUserAccountById(userId)
            .then(function(result) {
                //Success
                angular.copy(result, $scope.userAccount);
            }, function() {
                //Error
                alert("There was an error retrieving the user account");
            });
    }
}