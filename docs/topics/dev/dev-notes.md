
# Writing Test Case for new Worklfow

In general, a Test Case is a set of `GIVEN`, `WHEN`, and `THEN` steps, which involve
some **Client Code** that runs the *Code Under Test*

In Workflow (Unit) Testing, the Client code should be another (caller/consumer) Workflow.  

There are 2 ways for implementing a Test Case in our Test Suite:

- Running Reusable Workflow in a **Test Case** that is a `Caller Workflow`

    - with GIVENs, WHENs, THENs, and the Client Code being a Job that directly calls Resuable Workflow

- Running Reusable Workflow indirectly, in a **Test Case** that triggers `Caller Workflow`

    - with GIVENs, WHENs, THENs, and the Client Code being a 3rd-party `Caller Workflow`

## Development Notes

At our public API surface, we offer Reusable Workflows.

When we want to release a new **Reusable Workflow**, we should implement at least 1 new
Test Case to "cover" it.

This implies creating a new `Test Case Workflow` in one of below **forms**:

- as a `Caller Workflow` of the new **Reusable Workflow**
- as a `Workflow triggering` indirectly a 3rd-party `Caller Workflow`

### Picking up Test Case Form

Here you will find a **Flow Chart** documenting the *process* of creating a `New Test Case`

```mermaid
---
title: Adding Case to Automated Test Suite
---

%% Adding a Test Case in the Test Suite

%% if Test Case is a Caller Workflow in cicd-repo, then use infra to pick up your workflow

flowchart TB

    create_cicd_test_workflow("`Add a Workflow
    in *cicd-test*`")

    create_cicd_test_workflow --> should_directly_call_workflow

    should_directly_call_workflow{"`Should we **directly Call**
    the **new Workflow**
    in our **Test Case**?`"}

    %% YES: Test Case should be a Caller Workflow in cicd-repo
    %% Typical Workflow Jobs graph:
    %% setup_givens_n_expectations -> call_new_workflow -> make_assertions

    should_directly_call_workflow --yes --> test_case_calls_new_workflow

    test_case_calls_new_workflow("`Add Jobs
    'setup' -> 'call' -> 'assert'`")



    %% NO: Test Case cannot simply call the new Workflow
    %% Assumes there is a "3rd-party" Caller Workflow
    %% Test Case should ensure it's GIVEN's/WHEN's triggers the 3rd-party Worklfow

    should_directly_call_workflow --"`no: Assume *3rd-party*
    Caller Workflow exists`" --> test_case_triggers_caller_of_new_workflow


    test_case_triggers_caller_of_new_workflow("`Ensure the *3rd-party*
    Caller **Workflow**
    is triggered`")

    test_case_calls_new_workflow --> are_assertions_complex
    test_case_triggers_caller_of_new_workflow --> are_assertions_complex

    are_assertions_complex{"`Is *assertions* logic
    **too complex**?`"}

    are_assertions_complex --yes --> dedicate_pytest_function_for_assertions

    dedicate_pytest_function_for_assertions("`Write Assertions Logic as
    new **Pytest function**
    in *cicd-test*`")

    dedicate_pytest_function_for_assertions --> pick_up_caller
    are_assertions_complex --no --> pick_up_caller


    %% Test Case is a Caller Workflow in cicd-repo



    pick_up_caller("`**Modify** *cicd-test* **Fixture**
    to Pick up your Workflow`")

    pick_up_caller --> is_green

    is_green{"`Is Workflow
    expected to be GREEN?`"}

    is_green --no --> modify_expectations

    modify_expectations("`**Modify Expectations**
    in *cicd-test* Test Suite`")

    modify_expectations --> modify_this_cicd_pipe

    is_green --yes --> modify_this_cicd_pipe

    modify_this_cicd_pipe("`Ensure **Test Case** is picked
    by Test Matrix of *this* **CI**`")


```
