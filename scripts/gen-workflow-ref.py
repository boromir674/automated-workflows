#!/usr/bin/env python3

import typing as t

from typing import TypedDict

import argparse
from pathlib import Path
import yaml
from yaml.resolver import Resolver

#### TYPES ####

## Resuable Workflow 'inputs' ##
class InputArgument(TypedDict):
    required: bool  # allowed values {True, False}
    type: str  # common values {'string', 'boolean', 'number'}

## Resuable Workflow 'secrets' ##
class SecretArgument(TypedDict):
    required: bool  # allowed values {True, False}

## Resuable Workflow 'outputs' ##
class OutputArgument(TypedDict):
    description: str
    value: t.Union[str, int, float, bool, t.List]

## Resuable Workflow; data under 'workflow_call' (inside 'on' section) ##
class ResuableWorkflowInterface(TypedDict):
    """Keys found under the 'workflow_call' key (which is under the 'on' key)"""
    inputs: t.Dict[str, InputArgument]
    secrets: t.Dict[str, SecretArgument]
    outputs: t.Dict[str, OutputArgument]

class Events(TypedDict):
    """Keys found under the 'on' key"""
    workflow_call: ResuableWorkflowInterface

## Job item in 'jobs' list, in document level ##
JobDataInterface = TypedDict('JobDataInterface', {
    'runs-on': str,
    'if': str,
    'name': str,
    'needs':t.List[str],
    'steps': t.List[t.Dict[str, t.Any]],
})

class JobData(JobDataInterface, total=False):
    pass

### Resuable Workflow ###
WorkflowData = TypedDict('WorkflowData', {
    'on': Events,
    # 'on': {
    #     'workflow_call': ResuableWorkflowInterface,
    # },
    'jobs': t.Dict[str, JobData],
    'if': str,
})


def parse_workflow(
    workflow_data: WorkflowData
) -> t.Tuple[str, t.Dict[str, t.Optional[t.Any]], ResuableWorkflowInterface, t.Dict[str, t.Any]]:

    # pipeline_jobs: t.Dict[str, JobData] = workflow_data["jobs"]

    # pipeline_jobs: t.List[JobData] = workflow_data.get("jobs", {}).get("docker_build", {})

    ## Read the job name, if Reusable Workflow declares only 1 job ##
    # job_name: t.Optional[str] = None
    # if len(pipeline_jobs) == 1:
    #     for jobname, job_data in pipeline_jobs.items():
    #         job_name = job_data.get("name", jobname)

    ## Read Trigger Events; they trigger the workflow, whenever they occur ##
    events: t.Dict[str, t.Optional[t.Any]] = workflow_data.get('on', {})

    # anticipate, that we read a Resuable Github Actions Workflow
    # so we expect the 'workflow_call' key to be present, under 'on' key
    workflow_interface: ResuableWorkflowInterface = events['workflow_call']

    # Extract workflow top-level env vars
    env_section: t.Dict[str, t.Any] = workflow_data.get("env", {})

    return events, workflow_interface, env_section


def generate_markdown(
    workflow_name: str,
    events: t.Dict[str, t.Optional[t.Any]],
    workflow_interface: ResuableWorkflowInterface,
    env_section: t.Dict[str, t.Any],
    max_mk_level: int = 2  # max markdown heading level to write
):
    # string buffer to hold markdown content
    # Write Markdown Top Level Header (#)
    markdown_content: str = ''
    # markdown_content: str = f"# {workflow_name}\n\n"

    # destructure workflow_interface
    inputs: t.Dict[str, InputArgument] = workflow_interface.get("inputs", {})
    secrets: t.Dict[str, SecretArgument] = workflow_interface.get("secrets", {})
    outputs: t.Dict[str, OutputArgument] = workflow_interface.get("outputs", {})

    # Workflow Events - Section #
    markdown_content += f"{'#' * (max_mk_level + 1)} Trigger Events\n\n"
    markdown_content += (
        f"If any of the below events occur, the `{workflow_name}` workflow "
        "will be triggered.\n\n"
    )
    # events List
    for event in events.keys():
        markdown_content += f"- {event}\n"
    markdown_content += "\n"
    markdown_content += (
        f"Since there is a `workflow_call` _trigger_event_, this workflow can "
        "be triggered (called) by another (caller) workflow.\n"
        "> Thus, it is a `Reusable Workflow`.\n\n"
    )
    # Workflow env vars - Section #
    markdown_content += (
        f"{'#' * max_mk_level} Environment Variables\n\n"
        f"Environment variables set in the workflow's `env` section:\n"
        '\n'.join([f"- {env_var_name}: {env_var_value}" for env_var_name, env_var_value in env_section.items()]) + \
        "\n"
    )
    # Resuable Workflow - Section #
    markdown_content += f"{'#' * max_mk_level} Reusable Workflow\n\n"
    markdown_content += (
        f"Event Trigger: `workflow_call`\n\n"
    )
    ## Workflow Inputs ##
    markdown_content += f"{'#' * (max_mk_level + 1)} Inputs\n\n"
    required_inputs: t.Set[str] = {x for x in inputs.keys() if inputs[x].get("required", False)}
    markdown_content += f"{'#' * (max_mk_level + 2)} Required Inputs\n\n"
    for input_name in required_inputs:
        markdown_content += f"- `{input_name}`\n"
        markdown_content += f"    - type: _{inputs[input_name].get('type', 'string')}_\n"
        markdown_content += f"    - Description: {inputs[input_name].get('description', '')}\n"
    markdown_content += "\n"
    # Optional Inputs
    optional_inputs: t.Set[str] = {x for x in inputs.keys() if x not in required_inputs}
    markdown_content += f"{'#' * (max_mk_level + 2)} Optional Inputs\n\n"
    for input_name in optional_inputs:
        markdown_content += f"- `{input_name}`\n"
        markdown_content += f"    - type: _{inputs[input_name].get('type', 'string')}_\n"
        markdown_content += f"    - Description: {inputs[input_name].get('description', '')}\n"
    markdown_content += "\n"

    ## Workflow Secrets ##
    markdown_content += f"{'#' * (max_mk_level + 1)} Secrets\n\n"
    for secret_name, secret_details in secrets.items():
        markdown_content += f"- `{secret_name}`\n"
        markdown_content += f"    - type: _{secret_details.get('type', 'string')}_\n"
        markdown_content += f"    - Required: {secret_details.get('required', False)}\n"
        markdown_content += f"    - Description: {secret_details.get('description', '')}\n"
    markdown_content += "\n"

    ## Workflow Outputs ##
    markdown_content += f"{'#' * (max_mk_level + 1)} Outputs\n\n"
    for output_name, output_details in outputs.items():
        markdown_content += f"- `{output_name}`\n"
        markdown_content += f"    - type: _{output_details.get('type', 'string')}_\n"
        markdown_content += f"    - Value: {output_details.get('value', '')}\n"
        markdown_content += f"    - Description: {output_details.get('description', '')}\n"
    markdown_content += "\n"

    # markdown_content += "### Environments\n\n"
    # for environment_name, environment_value in repository_details["environments"].items():
    #     markdown_content += f"- {environment_name}: {environment_value}\n"
    # markdown_content += "\n"

    return markdown_content


##### YAML Workflow PARSER #####
def parse_workflow_file(workflow_file: Path) -> WorkflowData:
    # the 'on' yaml section, which is used for declaring what events trigger the workflow,
    # is parsed by default as an (inner) dict mapped not by a 'on' string but by the True boolean value!
    # About this behaviour see:
    # - https://stackoverflow.com/questions/36463531/pyyaml-automatically-converting-certain-keys-to-boolean-values
    # - https://docs.saltstack.com/en/latest/topics/troubleshooting/yaml_idiosyncrasies.html

    # we explicitly define the YAML behaviour so we parse sections with this behaviour
    # as strings instead of the True boolean value

    # remove resolver entries for On/Off/Yes/No
    for ch in "OoYyNn":
        if len(Resolver.yaml_implicit_resolvers[ch]) == 1:
            del Resolver.yaml_implicit_resolvers[ch]
        else:
            Resolver.yaml_implicit_resolvers[ch] = [x for x in
                    Resolver.yaml_implicit_resolvers[ch] if x[0] != 'tag:yaml.org,2002:bool']
    file_content: str = workflow_file.read_text()
    return yaml.safe_load(file_content)


##### CLI Args READ #####
def parse_cli_args() -> t.Tuple[Path, t.Optional[str]]:
    """
    Parse command line arguments for processing a .github/workflows/*.yaml file.

    Returns:
        Tuple[Path, Optional[str]]: Tuple containing the Path to the workflow YAML file
        and an optional output path. If not specified, the result is printed to stdout.
    """
    parser = argparse.ArgumentParser(description='Process a .github/workflows/*.yaml file')
    parser.add_argument(
        'workflow_path',
        help='Path to the workflow YAML file. Example: my_workflow.yaml',
        metavar='WORKFLOW_PATH'
    )
    parser.add_argument(
        '-o', '--output',
        help='Output path. If not specified, the result will be printed to stdout.',
        metavar='OUTPUT_PATH'
    )
    args = parser.parse_args()

    # Convert the provided path to a Path object
    workflow_file: Path = Path(args.workflow_path)

    # If the provided file path doesn't exist, try finding it in the current working directory
    if not workflow_file.exists():
        workflow_file = Path.cwd() / args.workflow_path

    return workflow_file, args.output


######## MAIN ########
def main():
    workflow_file, output_dest = parse_cli_args()

    # Read the GitHub Actions workflow file in a dict
    workflow_data = parse_workflow_file(workflow_file)

    # Parse workflow data
    events, workflow_interface, env_section = parse_workflow(workflow_data)

    # Generate Markdown content
    markdown_content = generate_markdown(
        workflow_file.name,
        events,
        workflow_interface,
        env_section,
        max_mk_level=2
    )

    # Add Top Level Header with Document Title
    markdown_content = f"# Workflow {workflow_file.name}\n\n" + markdown_content

    # Print Markdown content to stdout if no output path is specified
    if output_dest is None:
        print(markdown_content)
        return
    # Write Markdown content to a file
    with open(output_dest, 'w') as f:
        f.write(markdown_content)


if __name__ == "__main__":
    main()

# Usage example: ./scripts/gen-workflow-ref.py ./.github/workflows/docker.yml > ./docs/ref_docker.md