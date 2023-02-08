## Description & motivation: 
Describe your changes, and why you're making them. Is this linked to an open Jira ticket, or another pull request? Link it here.

## To-do before merge:
**(Optional -- remove this section if not needed)**
Include any notes about things that need to happen before this PR is merged.

## Screenshots:
Include screenshot(s) of the relevant section of the updated DAG. You can access your version of the DAG by running `dbt docs generate && dbt docs serve`.

## Validation of macros/models:
Include any output that confirms that the models do what is expected. This might be a link to an in-development dashboard in Tableau or BI tool, or a query that compares an existing model with a new one, or output of `dbt build` command execution.

## Changes to existing macros/models:
Include this section if you are changing any existing models. Link any related pull requests on Tableau or BI tool, or instructions for merge (e.g. whether old models should be dropped after merge, or whether a full-refresh run is required)

## Failure Strategy:
Include action required to resolve the issue if your changes cause production failure. _e.g.: revert this merge request to return branch to its previous state_

## Checklist:
This checklist is mostly useful as a reminder of small things that can easily be forgotten – it is meant as a helpful tool rather than hoops to jump through.
Put an `x` in all the items that apply, make notes next to any that haven't been addressed, **and remove any items that are not relevant to this PR**.

- [ ] My pull request represents one logical piece of work.
- [ ] My commits are related to the pull request and look clean.
- [ ] My SQL follows the [dbt guide](https://postholdings.sharepoint.com/:w:/r/sites/PHI/shares/IT/decision_science/_layouts/15/Doc.aspx?sourcedoc=%7BC9780E0C-18F8-449F-8636-096FE0E14089%7D&file=dbt%20Architecture.docx&nav=eyJjIjo2NDE5OTkwMDR9&action=default&mobileredirect=true&cid=99f9e72c-9e00-4118-9406-c68c3a93d507).
- [ ] I have materialized my models appropriately.
- [ ] I have followed all of the standard naming conventions.
- [ ] I have created macros/models in their desired folder locations.
- [ ] I have provided failure strategy in case there are failures caused due to my changes.
- [ ] I have used re-used existing models when/where applicable.
- [ ] I have re-used existing macros or jinja functions when/where applicable.
- [ ] I have added appropriate tests and documentation to any new models.
- [ ] I have created new macros or jinja functions.
- [ ] I have modified existing macros or jinja functions.
- [ ] I have added new package(s) to packages.yml file.
- [ ] My pull request will modify dbt_project.yml file.
