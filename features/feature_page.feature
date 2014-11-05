Feature: Feature page

  Scenario: Visiting a feature's page

    Given there's a feature type 'CDS'

    When I am on the feature page
    Then I should see feature type 'CDS'
