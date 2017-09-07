FROM centos:6
RUN yum install -y epel-release
RUN rpm -U --force http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

# PHP関連
RUN yum install -y --enablerepo=remi-php54 php
RUN yum install -y --enablerepo=remi-php54 php-common php-pecl-xdebug php-xml php-devel php-pear-XML-Serializer php-password-compat php-symfony php-phpunit-PHPUnit php-phpunit-phpcpd php-pear-PHP-CodeSniffer php-phpmd-PHP-PMD php-pear-phing


# jenkins構築
RUN yum install -y java-1.8.0-openjdk-devel
RUN curl -o /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
RUN rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
RUN yum -y install rsyslog
RUN yum install -y jenkins
RUN chkconfig jenkins on
RUN service jenkins start
RUN curl -L http://updates.jenkins-ci.org/update-center.json | sed '1d;$d' | curl -X POST -H 'Accept: application/json' -d @- http://localhost:8080/updateCenter/byId/default/postBack
RUN curl -o /tmp/jenkins-cli.jar http://localhost:8080/jnlpJars/jenkins-cli.jar
RUN java -jar /tmp/jenkins-cli.jar -s http://localhost:8080 install-plugin phing

ENTRYPOINT service jenkins restart && /bin/bash
