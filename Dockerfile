FROM sameersbn/gitlab:7.14.3
MAINTAINER andrew.d.bruce@leidos.com

# not specified in base image:
#   GITLAB_ROOT_PASSWORD
#   LDAP_PASS
ENV \
  GITLAB_HOST='lmgitlab.hlsdev.com' \
  GITLAB_PORT='80' \
  GITLAB_HTTPS='false' \
  GITLAB_ROOT_EMAIL='admin@hlsdev.local' \
  GITLAB_EMAIL='admin@hlsdev.local' \
  GITLAB_EMAIL_DISPLAY_NAME='LM Gitlab' \
  GITLAB_EMAIL_REPLY_TO='noreply@hlsdev.local' \
  GITLAB_INCOMING_EMAIL_ENABLED='false' \
  GITLAB_SIGNUP_ENABLED='false' \
  GITLAB_USERNAME_CHANGE='false' \
  SMTP_ENABLED='true' \
  SMTP_DOMAIN='hlsdev.local' \
  SMTP_HOST='smtp.hlsdev.local' \
  SMTP_PORT='25' \
  LDAP_ENABLED='true' \
  LDAP_HOST='ldap.hlsdev.local' \
  LDAP_PORT='636' \
  LDAP_UID='uid' \
  LDAP_METHOD='tls' \
  LDAP_BIND_DN='uid=ldap_access,cn=users,cn=accounts,dc=hlsdev,dc=local' \
  LDAP_ACTIVE_DIRECTORY='false' \
  LDAP_ALLOW_USERNAME_OR_EMAIL_LOGIN='false' \
  LDAP_BLOCK_AUTO_CREATED_USERS='true' \
  LDAP_BASE='cn=users,cn=accounts,dc=hlsdev,dc=local' \
  LDAP_USER_FILTER='(memberOf=cn=active_users,cn=groups,cn=accounts,dc=hlsdev,dc=local)' \
  OAUTH_ENABLED='false' \
  GITLAB_GRAVATAR_ENABLED='true'

