REPO_NAME='hecil-worker'
PREFIX='hyperflowwms'
JOB_EXECUTOR_SHORT='je'
HF_JOB_EXECUTOR_VERSION='1.3.4'
TAG=$(JOB_EXECUTOR_SHORT)-$(HF_JOB_EXECUTOR_VERSION)

all: push

container: image

image:
	docker build --build-arg hf_job_executor_version=$(HF_JOB_EXECUTOR_VERSION) -t $(PREFIX)/$(REPO_NAME) . # Build new image and automatically tag it as latest
	docker tag $(PREFIX)/$(REPO_NAME) $(PREFIX)/$(REPO_NAME):$(TAG)  # Add the version tag to the latest image

test:
	tar -C $(HOME) -zcvf hyperflow-job-executor.tar.gz hyperflow-job-executor 
	docker build --build-arg hf_job_executor_version=$(HF_JOB_EXECUTOR_VERSION) -t $(PREFIX)/$(REPO_NAME) . 

push: image
	docker push $(PREFIX)/$(REPO_NAME) # Push image tagged as latest to repository
	docker push $(PREFIX)/$(REPO_NAME):$(TAG) # Push version tagged image to repository (since this image is already pushed it will simply create or update version tag)

clean:
