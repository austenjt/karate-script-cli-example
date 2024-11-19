Feature: JSON Placeholder CRUD operations

  Background:
    * url 'https://jsonplaceholder.typicode.com'

  Scenario: Create a new post
    Given path 'posts'
    And request { title: 'foo', body: 'bar', userId: 1 }
    When method post
    Then status 201
    And match response.id == 101

  Scenario: Get a post
    Given path 'posts', 1
    When method get
    Then status 200
    And match response == { id: 1, title: '#string', body: '#string', userId: '#number' }

  Scenario: Update a post
    Given path 'posts', 1
    And request { title: 'updated title', body: 'updated body', userId: 1 }
    When method put
    Then status 200
    And match response == { id: 1, title: 'updated title', body: 'updated body', userId: 1 }

  Scenario: Edit a post
    Given path 'posts', 1
    And request { title: 'partially updated title' }
    When method patch
    Then status 200
    And match response.title == 'partially updated title'
