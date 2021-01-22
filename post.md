Currently, Terraform only allows you to (1) build your cloud resources, and (2) destroy your cloud resources.

It doesn’t let you “pause/resume” your compute instances.

I can understand that it may be atypical for a production system to need a feature like this. But for those who may be using Terraform for experimental infrastructure or for task-specific heavy machines … it would sure help to be able to “save progress” while not paying for on-demand compute.


## Why Terraform doesn’t yet have a “pause/resume” feature
I’m not completely sure why. But this has been an open issues since 2015. There have been a few open PRs [[1](https://github.com/hashicorp/terraform-provider-aws/pull/1980), [2](https://github.com/hashicorp/terraform/issues/1579)] to attempt to add this feature but none were completed.

My best (but probably inaccurate/incomplete) understanding of the issue is that adding this feature would add a whole lot of confusion concerning Terraform’s representation of “state”.

For example, currently Terraform only needs to manage two states and the transition between these two states (build <-> destroy). Adding two or more states to this model, and then having to handle transitions between ALL states could add some complexity.

Additionally, the pausing/resuming of compute instances may cause side effects to other attributes. For example an ephemeral public IP address only associated with the instance while it is running may disappear once it leaves the running state. These kinds of attributes would need to be taken into account.

This complexity doesn’t sound impossible, but it seems nobody wants to take initiative to build out an official implementation. And neither do I!! So here is my workaround.


## My workaround
I simply resorted to using the AWS CLI to perform the “stop” and “start” functions. I’ve packaged it in a handy way as shown in the Makefile below.
```
help: ## Show this help
    @egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## Build AWS infrastructure
    terraform init
    terraform apply

destroy: ## Destroy AWS infrastructure
    terraform destroy

pause: ## Shut down the AWS instances but save their storage
    terraform show -no-color | grep "\sid\s" | tr -d ' ' | cut -c 5-23 | tr '\n' ' ' > instance_ids.txt
    aws ec2 stop-instances --instance-ids $$(cat instance_ids.txt)
    rm instance_ids.txt

resume: ## Start the AWS instances that were paused
    terraform show -no-color | grep "\sid\s" | tr -d ' ' | cut -c 5-23 | tr '\n' ' ' > instance_ids.txt
    aws ec2 start-instances --instance-ids $$(cat instance_ids.txt)
    rm instance_ids.txt
```


## Future work
This has only been tested on a very basic use case. I have yet to think through how it would perform in more complex architectures with more moving pieces.
