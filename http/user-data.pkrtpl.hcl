#cloud-config
autoinstall:
    version: 1
    locale: en_US.UTF-8
    keyboard:
      layout: us
    identity:
      hostname: ubuntu
      username: ubuntu
      password: "${user_password_hash}"
    user-data:
      disable_root: false
      users:
        - name: ubuntu
          sudo: ALL=(ALL) NOPASSWD:ALL
          shell: /bin/bash
          ssh_authorized_keys:
            - ${ssh_pub_key}
    ssh:
      install-server: true
      allow-pw: true
    storage:
      layout:
        name: direct
    updates: security
    package_update: false
    package_upgrade: false
    reboot: true
    late-commands:
      - curtin in-target --target=/target -- mkdir -p /etc/sudoers.d
      - curtin in-target --target=/target -- sh -c "echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ubuntu"
      - curtin in-target --target=/target -- chmod 440 /etc/sudoers.d/ubuntu
      - curtin in-target --target=/target -- sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
    interactive-sections: []