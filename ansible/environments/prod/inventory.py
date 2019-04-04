#!/usr/bin/python3

from subprocess import Popen, PIPE


def terraform_out(external_ip):
    cmd = "cd /vagrant_data/infra/terraform/prod && terraform output " + external_ip
    proc = Popen(cmd, shell = True, stdout=PIPE, stderr=PIPE)
    proc.wait()    # дождаться выполнения
    res = proc.communicate()  # получить tuple('stdout', 'stderr')
    if proc.returncode:
        return (res[1].decode())
    return (res[0].decode().strip())

app_external_ip = terraform_out("app_external_ip")
db_external_ip = terraform_out("db_external_ip")
db_internal_ip = terraform_out("db_internal_ip")

#print (app_external_ip)
#print (db_external_ip)


to_json = '''
{
    "_meta": {
        "hostvars": {
            "appserver": {
                "ansible_ssh_host": "''' +  app_external_ip +'''",
                "db_host": "''' + db_internal_ip + '''",
            },
            "dbserver": {
                "ansible_ssh_host": "''' + db_external_ip +'''",
            }
        }
    },
    "all": {
        "children": [
            "app",
            "db",
        ]
    },
    "app": {
        "hosts": [
            "appserver"
        ]
    },
    "db": {
        "hosts": [
            "dbserver"
        ]
    }
}
'''

print (to_json)
