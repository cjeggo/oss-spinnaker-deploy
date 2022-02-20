# This will create a yaml file that we can then pass thorugh kubectl apply
# Do it here so we can pick up TF vars
resource "local_file" "ServiceManifest" {
    filename = "./spinnaker/SpinnakerService.yml"
    content  = <<EOF
apiVersion: spinnaker.io/v1alpha2
kind: SpinnakerService
metadata:
  name: spinnaker
  namespace: spinnaker
spec:
  spinnakerConfig:               
    config:
      security:
        apiSecurity:
          overrideBaseUrl: https://${aws_route53_record.gate-record.name}
        uiSecurity:
          overrideBaseUrl: https://${aws_route53_record.deck-record.name}

      version: 1.26.6

      persistentStorage:
        persistentStoreType: s3
        s3:
            bucket: ${aws_s3_bucket.S3-bucket.bucket}
            rootFolder: front50
            region: ${var.aws_region}
            accessKeyId: ${var.aws_key}
            secretAccessKey: ${var.aws_secret}
      
      canary:
        enabled: true

      providers:
        aws:
          enabled: true
          accessKeyId: ${var.aws_key}
          secretAccessKey: ${var.aws_secret}
          accounts:
          - name: "oss-aws"
            requiredGroupMembership: []
            providerVersion: V1
            permissions: {}
            accountId: "${var.aws_account}"
            regions:
            - name: ${var.aws_region}
            assumeRole: role/aws-spin-support-managedrole
          primaryAccount: "oss-aws"

        kubernetes:
          enabled: true
          accounts:
          - name: "oss-kubernetes"
            requiredGroupMembership: []
            providerVersion: V2
            permissions: {}
            dockerRegistries: []
            configureImagePullSecrets: true
            cacheThreads: 5
            namespaces: ["oss-kubernetes"] # Change if you only want to deploy to specific namespaces
            kinds: []
            omitKinds: []
            customResources: []
            cachingPolicies: []
            oAuthScopes: []
            onlySpinnakerManaged: true
            kubeconfigFile: encryptedFile:s3!r:${var.aws_region}!b:${aws_s3_bucket.S3-bucket.bucket}!f:kubeconfig
          primaryAccount: "oss-kubernetes" 

      features:
        artifacts: true
        
      artifacts:
        s3:
          enabled: true
          accounts:
          - name: "oss-aws"
        github:
          enabled: true
          accounts:
          - name: github
            token: ${var.github_pat} 

    # spec.spinnakerConfig.profiles - This section contains the YAML of each service's profile
    profiles:

      clouddriver: 
        artifacts:
          gitRepo:
            enabled: true
            accounts:
            - name: ${var.spinnaker_github_repo}
              token: ${var.github_pat}

      # deck has a special key "settings-local.js" for the contents of settings-local.js
      deck:
        # settings-local.js - contents of ~/.hal/default/profiles/settings-local.js
        # Use the | YAML symbol to indicate a block-style multiline string
        settings-local.js: |
          window.spinnakerSettings.feature.kustomizeEnabled = true;
          window.spinnakerSettings.feature.artifactsRewrite = true;
          window.spinnakerSettings.feature.terraform = true;
          window.spinnakerSettings.feature.functions = true;

      echo: {}    # is the contents of ~/.hal/default/profiles/echo.yml
      fiat: {}    # is the contents of ~/.hal/default/profiles/fiat.yml
      front50: {} # is the contents of ~/.hal/default/profiles/front50.yml
      gate: {}    # is the contents of ~/.hal/default/profiles/gate.yml
      igor: {}    # is the contents of ~/.hal/default/profiles/igor.yml
      kayenta: {} # is the contents of ~/.hal/default/profiles/kayenta.yml
      orca: {}
      rosco: {}   # is the contents of ~/.hal/default/profiles/rosco.yml
      dinghy:
        repoConfig:
          - branch: main
            provider: github
            repo: ${var.spinnaker_github_repo}

    # spec.spinnakerConfig.service-settings - This section contains the YAML of the service's service-setting
    # see https://www.spinnaker.io/reference/halyard/custom/#tweakable-service-settings for available settings
    service-settings:
      clouddriver: {}
      deck: {}
      echo: {}
      fiat: {}
      front50: {}
      gate: {}
      igor: {}
      kayenta: {}
      orca: {}
      rosco: {}

    # spec.spinnakerConfig.files - This section allows you to include any other raw string files not handle above.
    # The KEY is the filepath and filename of where it should be placed
    #   - Files here will be placed into ~/.hal/default/ on halyard
    #   - __ is used in place of / for the path separator
    # The VALUE is the contents of the file.
    #   - Use the | YAML symbol to indicate a block-style multiline string
    #   - We currently only support string files
    #   - NOTE: Kubernetes has a manifest size limitation of 1MB
    files: {}
  #      profiles__rosco__packer__example-packer-config.json: |
  #        {
  #          "packerSetting": "someValue"
  #        }
  #      profiles__rosco__packer__my_custom_script.sh: |
  #        #!/bin/bash -e
  #        echo "hello world!"


  # spec.expose - This section defines how Spinnaker should be publicly exposed
  expose: {}
    # type: service            # Spinnaker is exposed using kubernetes services. Available options: service, ingress
    # service:
    #   type: LoadBalancer     # Kubernetes service type used to expose Spinnaker. Can be ClusterIP, NodePort or LoadBalancer.
    #   overrides:
    #     gate:
    #       publicPort: 8084   # (Optional). Port used to expose Gate.
    #       nodePort: 30586
    #     deck:
    #       publicPort: 9000   # (Optional). Port used to expose Deck.
    #       nodePort: 31015

      # annotations to be set on Kubernetes LoadBalancer type
      # they will only apply to spin-gate, spin-gate-x509, or spin-deck
      # annotations:
      #   service.beta.kubernetes.io/aws-load-balancer-backend-protocol: http
        # uncomment the line below to provide an AWS SSL certificate to terminate SSL at the LoadBalancer
        #service.beta.kubernetes.io/aws-load-balancer-ssl-cert: arn:aws:acm:us-west-2:9999999:certificate/abc-123-abc

      # Provided below is the example config for the Gate-X509 configuration
#        deck:
#          annotations:
#            service.beta.kubernetes.io/aws-load-balancer-ssl-cert: arn:aws:acm:us-west-2:9999999:certificate/abc-123-abc
#            service.beta.kubernetes.io/aws-load-balancer-backend-protocol: http
#        gate:
#          annotations:
#            service.beta.kubernetes.io/aws-load-balancer-ssl-cert: arn:aws:acm:us-west-2:9999999:certificate/abc-123-abc
#            service.beta.kubernetes.io/aws-load-balancer-backend-protocol: https  # X509 requires https from LoadBalancer -> Gate
#       gate-x509:
#         annotations:
#           service.beta.kubernetes.io/aws-load-balancer-backend-protocol: tcp
#           service.beta.kubernetes.io/aws-load-balancer-ssl-cert: null
#         publicPort: 443
  kustomize:
    deck:
      service:
        patches:
          - |
            spec:
              type: LoadBalancer
              ports:
              - name: http
                port: 9000
                targetPort: 9000
                nodePort: 31015
    gate:
      service:
        patches:
        - |
          spec:
            type: LoadBalancer
            ports:
            - name: http
              port: 8084
              targetPort: 8084
              nodePort: 30586
EOF
}