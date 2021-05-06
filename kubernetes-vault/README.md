Вывод helm status vault
```shell
NAME: vault
LAST DEPLOYED: Thu May  6 16:23:26 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Thank you for installing HashiCorp Vault!

Now that you have deployed Vault, you should look over the docs on using
Vault with Kubernetes available here:

https://www.vaultproject.io/docs/


Your release is named vault. To learn more about the release, try:

  $ helm status vault
  $ helm get manifest vault
```

Вывод 'kubectl exec -it vault-0 -- vault operator init --key-shares=1 --key-threshold=1'
```shell
Unseal Key 1: QEMBOXiC9CtGJfPBxcQjfMyLOQBxobCqaMohhx2w7tk=

Initial Root Token: s.aRB7K5jOngDsYc27CYmJ2AST

Vault initialized with 1 key shares and a key threshold of 1. Please securely
distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 1 of these keys to unseal it
before it can start servicing requests.

Vault does not store the generated master key. Without at least 1 key to
reconstruct the master key, Vault will remain permanently sealed!

It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault operator rekey" for more information.
```

Вывод vault status
```shell
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    1
Threshold       1
Version         1.7.0
Storage Type    consul
Cluster Name    vault-cluster-e008bd36
Cluster ID      022cb67f-4131-9116-8402-ac8bdc55a018
HA Enabled      true
HA Cluster      https://vault-0.vault-internal:8201
HA Mode         active
Active Since    2021-05-06T13:28:26.705830138Z
```

Вывод после vault login
```shell
Token (will be hidden):
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                  Value
---                  -----
token                s.aRB7K5jOngDsYc27CYmJ2AST
token_accessor       LP9Z68oDeqWs7Xh94I19TKI4
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]
```

Вывод vault auth list
```shell
Path      Type     Accessor               Description
----      ----     --------               -----------
token/    token    auth_token_76a77ca8    token based credentials
```

Вывод 'vault kv get otus/otus-rw/config'
```shell
====== Data ======
Key         Value
---         -----
password    asajkjkahs
username    otus
```

Обновленный список авторизаций
```shell
Path           Type          Accessor                    Description
----           ----          --------                    -----------
kubernetes/    kubernetes    auth_kubernetes_d404180b    n/a
token/         token         auth_token_76a77ca8         token based credentials
```


Поправил команду получения K8S_HOST
```shell
export K8S_HOST=$(kubectl cluster-info | grep 'Kubernetes control plane' | awk '/https/ {print $NF}' | sed 's/\x1b\[[0-9;]*m//g' )
```

Из-за ошибки: tar: can't open 'otus-policy.hcl': Permission denied
Поправил команды:
```shell
kubectl cp otus-policy.hcl vault-0:./tmp
kubectl exec -it vault-0 -- vault policy write otus-policy /tmp/otus-policy.hcl
```

Почему мы смогли записать otus-rw/config1, но не смогли otus-rw/config ?
Ответ на вопрос:
В политики otus-policy.hcl не определены права на изменение, нужно добавить capabilities "update"

index.html
```shell
<html>
<body>
<p>Some secrets:</p>
<ul>
<li><pre>username: otus</pre></li>
<li><pre>password: asajkjkahs</pre></li>
</ul>

</body>
</html>
```

Вывод при создании сертификата
```shell
Key                 Value
---                 -----
ca_chain            [-----BEGIN CERTIFICATE-----
MIIDnDCCAoSgAwIBAgIUDc2GRxWWooL8ph5OXIuuCa3uz9swDQYJKoZIhvcNAQEL
BQAwFTETMBEGA1UEAxMKZXhtYXBsZS5ydTAeFw0yMTA1MDYxNTE2MzJaFw0yNjA1
MDUxNTE3MDJaMCwxKjAoBgNVBAMTIWV4YW1wbGUucnUgSW50ZXJtZWRpYXRlIEF1
dGhvcml0eTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMKUV1JQwyFY
ViGKMkGX339zw3kn7XcoWXjaKTFUMug1txcsSuO4/OcSfvp3klXaZdP0LnRf/ejd
6pQBpMtC1GaviqhWW+aVROL+2Pa+mzMcmZYPHPw3ues+6QlV9Pgb3tuh4Wsphv2Z
hEIBjGY2QV+J6eQrcYgOtck1oYfajxePbAZ2UWHc/t2IYgOYK0nS+VECGvmW8DBi
MIOPgNBUWDxk5jP3VD+duu0dFjE/h7/VPI9A8Gg5UW1F0EsQkrNKHtqy4+OqPyD/
KOA7Ldi3FlXGwOtp7N9G7juK+ViBJ5vmXAFLsgvQrh9h30jstMntNRbjgiEGlJX1
QXtcLdOlqmUCAwEAAaOBzDCByTAOBgNVHQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUw
AwEB/zAdBgNVHQ4EFgQUhEsmSbppLkDUSNgSyfdiNYU1320wHwYDVR0jBBgwFoAU
Tp537Q3ZXDEbHbfTNuy6tug+yN0wNwYIKwYBBQUHAQEEKzApMCcGCCsGAQUFBzAC
hhtodHRwOi8vdmF1bHQ6ODIwMC92MS9wa2kvY2EwLQYDVR0fBCYwJDAioCCgHoYc
aHR0cDovL3ZhdWx0OjgyMDAvdjEvcGtpL2NybDANBgkqhkiG9w0BAQsFAAOCAQEA
74BIu++BefXqIbbMfkTmcqLHja0WoVWU5Bjlic2nYRbPH9bTjojinGGAyFxCoUFr
eayw4sRA0Vlpf4Fr6DXcQimDP3KyJbcAiegLzMSWCXuoxeHCGJkE7sNqZ/sAuBNM
tOGX3z/jXpSiPeAypaleOYlZs3lEU2ziYuJJ5sFa1z0OzuhxyHtGqMqnfs45HxOE
UbQP22tCUBsiUINUid0CbDsYrv8EAZAkTDxCUV3s1/oXFmHDPMhcHT2AtrV6UVR9
WafCd5TjCYxJm5hRI0We2/cH8og8XSUgI405OVZxlQFo5FtOM7LAfwog18fAveDQ
DPYYdFwKmsz1MfwX4UoYqA==
-----END CERTIFICATE-----]
certificate         -----BEGIN CERTIFICATE-----
MIIDZzCCAk+gAwIBAgIUMDQJ5NyszGYylrJbZmBmqkJrkmswDQYJKoZIhvcNAQEL
BQAwLDEqMCgGA1UEAxMhZXhhbXBsZS5ydSBJbnRlcm1lZGlhdGUgQXV0aG9yaXR5
MB4XDTIxMDUwNjE1MjIwOFoXDTIxMDUwNzE1MjIzOFowHDEaMBgGA1UEAxMRZ2l0
bGFiLmV4YW1wbGUucnUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDZ
YAA3GYrhW3wH3noLwUyCItFEFunRUZvXDLCaeSXecxgfphAvIDT48MNSHebit1iB
0+uITuehhzCkMV6kv42Nj+rFeKluJojYVZ0ikFJ54OBPMAzM5dux1TqQ8j5qVvdb
gUsUtJeT6sb9cfBURmGMlINZbmc4UeOpLGKV4LGHhw3n9tnX++bPEJp0OLSo/y9h
VZYR29OyQWzuED2a5v/0fMuVw9I+zkZdE5U3nnUViPnrFVccxfYFXButV9FDssyC
5jqaYKBHYuYHobeAak4tsnOHIgypKLu2jG/WZzNaiH53G0RnCZD5PdejnkPB/HyS
axYvYaLMDdmsKr1VVYOrAgMBAAGjgZAwgY0wDgYDVR0PAQH/BAQDAgOoMB0GA1Ud
JQQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjAdBgNVHQ4EFgQUv7j3FlNWEYxtfEW5
rSUKAaCP26swHwYDVR0jBBgwFoAUhEsmSbppLkDUSNgSyfdiNYU1320wHAYDVR0R
BBUwE4IRZ2l0bGFiLmV4YW1wbGUucnUwDQYJKoZIhvcNAQELBQADggEBADV7LCMm
n7pXyArC4wXpF1JDO+G0u35ZY/+OlewxOtlxxpKSG9cNZ/nFleM/C5Ajs+7UISER
hgv79ViAORqpQSTZGCHWzwsYbqtIdwmJyXyMen/iRqqUhmQVlrZjILl5mlyQexqV
4hz1E81vwBgXDS4gSOyWHgwzX+c7oRTL25u09fqWkRl8kUAleCFrzK2lAlXwLbCr
qCkPmqAxqIEjQ3jVLmbF4zFrx9cln3ZUkqdhCkOA8hSEOqHJmsggHdwG6MjSqdu9
1uMTM2eig9kuUmANN9QK1yhxTLMbZvJBuzBxsCOKNGDFtARW6N3FC/tBUIm1h8kD
VKRBNSozGbR1nZQ=
-----END CERTIFICATE-----
expiration          1620400958
issuing_ca          -----BEGIN CERTIFICATE-----
MIIDnDCCAoSgAwIBAgIUDc2GRxWWooL8ph5OXIuuCa3uz9swDQYJKoZIhvcNAQEL
BQAwFTETMBEGA1UEAxMKZXhtYXBsZS5ydTAeFw0yMTA1MDYxNTE2MzJaFw0yNjA1
MDUxNTE3MDJaMCwxKjAoBgNVBAMTIWV4YW1wbGUucnUgSW50ZXJtZWRpYXRlIEF1
dGhvcml0eTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMKUV1JQwyFY
ViGKMkGX339zw3kn7XcoWXjaKTFUMug1txcsSuO4/OcSfvp3klXaZdP0LnRf/ejd
6pQBpMtC1GaviqhWW+aVROL+2Pa+mzMcmZYPHPw3ues+6QlV9Pgb3tuh4Wsphv2Z
hEIBjGY2QV+J6eQrcYgOtck1oYfajxePbAZ2UWHc/t2IYgOYK0nS+VECGvmW8DBi
MIOPgNBUWDxk5jP3VD+duu0dFjE/h7/VPI9A8Gg5UW1F0EsQkrNKHtqy4+OqPyD/
KOA7Ldi3FlXGwOtp7N9G7juK+ViBJ5vmXAFLsgvQrh9h30jstMntNRbjgiEGlJX1
QXtcLdOlqmUCAwEAAaOBzDCByTAOBgNVHQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUw
AwEB/zAdBgNVHQ4EFgQUhEsmSbppLkDUSNgSyfdiNYU1320wHwYDVR0jBBgwFoAU
Tp537Q3ZXDEbHbfTNuy6tug+yN0wNwYIKwYBBQUHAQEEKzApMCcGCCsGAQUFBzAC
hhtodHRwOi8vdmF1bHQ6ODIwMC92MS9wa2kvY2EwLQYDVR0fBCYwJDAioCCgHoYc
aHR0cDovL3ZhdWx0OjgyMDAvdjEvcGtpL2NybDANBgkqhkiG9w0BAQsFAAOCAQEA
74BIu++BefXqIbbMfkTmcqLHja0WoVWU5Bjlic2nYRbPH9bTjojinGGAyFxCoUFr
eayw4sRA0Vlpf4Fr6DXcQimDP3KyJbcAiegLzMSWCXuoxeHCGJkE7sNqZ/sAuBNM
tOGX3z/jXpSiPeAypaleOYlZs3lEU2ziYuJJ5sFa1z0OzuhxyHtGqMqnfs45HxOE
UbQP22tCUBsiUINUid0CbDsYrv8EAZAkTDxCUV3s1/oXFmHDPMhcHT2AtrV6UVR9
WafCd5TjCYxJm5hRI0We2/cH8og8XSUgI405OVZxlQFo5FtOM7LAfwog18fAveDQ
DPYYdFwKmsz1MfwX4UoYqA==
-----END CERTIFICATE-----
private_key         -----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEA2WAANxmK4Vt8B956C8FMgiLRRBbp0VGb1wywmnkl3nMYH6YQ
LyA0+PDDUh3m4rdYgdPriE7noYcwpDFepL+NjY/qxXipbiaI2FWdIpBSeeDgTzAM
zOXbsdU6kPI+alb3W4FLFLSXk+rG/XHwVEZhjJSDWW5nOFHjqSxileCxh4cN5/bZ
1/vmzxCadDi0qP8vYVWWEdvTskFs7hA9mub/9HzLlcPSPs5GXROVN551FYj56xVX
HMX2BVwbrVfRQ7LMguY6mmCgR2LmB6G3gGpOLbJzhyIMqSi7toxv1mczWoh+dxtE
ZwmQ+T3Xo55Dwfx8kmsWL2GizA3ZrCq9VVWDqwIDAQABAoIBAGFom7AVSh7imBoO
oDJUVKycXZpdijm6kFM15I3UbBvbB5xnFimIDTTg7yYFMEm4T3keNhXHBhVkN2/c
j8TT8eLV8ya6g3JQ4lHPS7MJaWwkUWAq8BGBj4mJO81oQH/2qLHgpnyI0MQAGVvJ
iyC4yU3t305cIvUh/Rr6QNNY9TT9hD2a64OslX/8QrquxlCwCaxfp67kzA19uK+L
7mi7WVYfQUTPgOzqjF4d7vZFqy1Z/GfQBETF6jXVuUgoTB0tnwQx8qJFZVNFdejT
rfZO5ObkkAet+LLfhqIQk7+2v0cHOvU4oYFpPNZqIzbRKGPXZsEGMo9Efr0npV9I
/yM5MwECgYEA/oR7YizWQ2N4EMsAv+yNJ4UG6hs7LyDBIgs4hnaMpHz3vmM6TL9M
8hrb0IIfaRKR4rPoyEX8tI/q5tkiSF91mP34zAPlU7h/FFKBWZf4fxOHaUUtlo9G
0J3ZFPpBROUrmBFaaOicN9w5Oaj+3lUcLCL58+jDgU8AU6EHL0JWxHsCgYEA2qQi
eZBMQwFxUpQ3Cm26ZVZ5CSSdMzpQ41owpXVNBQ0q43XBeCPXlMIptQ0u+kW6IFXR
ufa0wyJ1DK3662FmTwyOHQepm2xqidMrL7m/vt+B8LKGn8u07PcqIk084iJ1x0Gr
LkCeCfdeobyFCwERCXDLIauac8MmvvUL/39cjpECgYEAnAe54EDeheeH5ruc1Qv+
qPibeY+CI+0vmWBJod0xcXGPK6+HQR+R22Zt1ZDAEtkoiFOE5KpLNqJ3/lek9btX
y5f/G4tT3pRfi6Tc2YEZ/UWKoRWg0gk5/5CVUY/tzX+0zv/sbh4UDwa6KkgZH1IL
+F7k3wuWN0KoT5yLXASOTtsCgYEAvXhJa+ExRUvFwZMxk3b9dX4XS2YQWGlr2Wm6
CFh7kyoTBaRxMUSWOJJ+BCjVkgrEverA4Y+6m/OLTZ6jeEEioNQ3f065mze7p454
uVYVpToZZ9W9tlKYilWyjKE0Zp8IQ9FTn7RdgDN/LVeqT5vwAKdfUOFd6n2uYQMI
D7R2KBECgYEA/UgFLx+JFw/5JSj7kEVTSplHQomtshxSyP+PPF1/7nSrsmro2oyt
aXMozWz+fe/qkHQqUJKXJlYgJLa3UzDl7HbOvda/Wzkk0Vc4Es5kAmo1Yy41uImj
oIgO/ZLYfMrMMNeq1IhFoaW0/FCVMYefZQR4jR3VLqIPycVTwG8lYEc=
-----END RSA PRIVATE KEY-----
private_key_type    rsa
serial_number       30:34:09:e4:dc:ac:cc:66:32:96:b2:5b:66:60:66:aa:42:6b:92:6b
```

Вывод отзыва сертификата
```shell
Key                        Value
---                        -----
revocation_time            1620314700
revocation_time_rfc3339    2021-05-06T15:25:00.658828031Z
```
