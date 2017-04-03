#!/bin/bash
# {{ ansible_managed }}

set -e

source /opt/duplicity_ansible/venv/bin/activate
DUPLICITY_BIN=/opt/duplicity_ansible/venv/bin/duplicity

{% if duplicity_aws_access_key_id %}
# AWS_ACCESS_KEY_ID
export AWS_ACCESS_KEY_ID={{ duplicity_aws_access_key_id }}
{% else %}
# duplicity_aws_access_key_id not defined
{% endif %}

{% if duplicity_aws_secret_access_key %}
# AWS_SECRET_ACCESS_KEY
export AWS_SECRET_ACCESS_KEY={{ duplicity_aws_secret_access_key }}
{% else %}
# duplicity_aws_secret_access_key not defined
{% endif %}

{% if duplicity_passphrase %}
# PASSPHRASE
export PASSPHRASE={{ duplicity_passphrase }}
{% else %}
# duplicity_passphrase not defined
{% endif %}


# Run the backup
${DUPLICITY_BIN} \
{% if duplicity_verbosity_level %}
    --verbosity {{ duplicity_verbosity_level }} \
{% endif %}
{% if duplicity_sign_key %}
    --sign-key {{ duplicity_sign_key }} \
{% endif %}
{% if duplicity_encrypt_key %}
    --encrypt-key {{ duplicity_encrypt_key }} \
{% endif %}
{% if duplicity_full_if_older_than is defined %}
    --full-if-older-than {{ duplicity_full_if_older_than }} \
{% endif %}
    --gpg-options "--always-trust" \
    {{ duplicity_src }} \
    {{ duplicity_dest }}


{% if duplicity_remove_all_but_n_full %}
# Remove old backups
${DUPLICITY_BIN} remove-all-but-n-full {{ duplicity_remove_all_but_n_full }} {{ duplicity_dest }}
{% endif %}

# Reset the ENV variables. Don't need them sitting around
{% if duplicity_aws_access_key_id %}
unset AWS_ACCESS_KEY_ID
{% endif %}

{% if duplicity_aws_secret_access_key %}
unset AWS_SECRET_ACCESS_KEY
{% endif %}

{%- if duplicity_passphrase %}
unset PASSPHRASE
{%- endif %}
