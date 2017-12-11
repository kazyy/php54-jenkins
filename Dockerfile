FROM centos:6
RUN yum install -y epel-release
RUN rpm -U --force http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
RUN ln -sf /usr/share/zoneinfo/Japan /etc/localtime

# PHP関連
RUN yum install -y --enablerepo=remi-php54 php
RUN yum install -y --enablerepo=remi-php54 php-common php-pecl-xdebug php-xml php-devel php-pear-XML-Serializer php-password-compat php-symfony php-phpunit-PHPUnit php-phpunit-phpcpd php-pear-PHP-CodeSniffer php-phpmd-PHP-PMD php-pear-phing
RUN sed -i 's/^memory_limit.*/memory_limit=512M/' /etc/php.ini
RUN echo "date.timezone=Asia/Tokyo" >> /etc/php.ini

# jenkins構築
RUN yum install -y java-1.8.0-openjdk-devel
RUN curl -o /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
RUN rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
RUN yum -y install rsyslog
RUN yum install -y jenkins

# プラグインインストール
ADD http://updates.jenkins-ci.org/download/plugins/apache-httpcomponents-client-4-api/4.5.3-2.0/apache-httpcomponents-client-4-api.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/command-launcher/1.1/command-launcher.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/mailer/1.20/mailer.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/external-monitor-job/1.7/external-monitor-job.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/ssh-credentials/1.13/ssh-credentials.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/analysis-core/1.93/analysis-core.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/crap4j/0.9/crap4j.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/xunit/1.102/xunit.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/ant/1.7/ant.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/jdepend/1.2.4/jdepend.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/htmlpublisher/1.14/htmlpublisher.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/plot/2.0.0/plot.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/violations/0.7.11/violations.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/javadoc/1.4/javadoc.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/display-url-api/2.1.0/display-url-api.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/junit/1.21/junit.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/matrix-project/1.12/matrix-project.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/structs/1.10/structs.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/matrix-auth/2.2/matrix-auth.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/antisamy-markup-formatter/1.5/antisamy-markup-formatter.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/script-security/1.35/script-security.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/jsch/0.1.54.1/jsch.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/workflow-step-api/2.13/workflow-step-api.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/credentials/2.1.16/credentials.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/maven-plugin/3.0/maven-plugin.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/cloverphp/0.5/cloverphp.hpi /var/lib/jenkins/plugins/

ADD http://updates.jenkins-ci.org/download/plugins/checkstyle/3.49/checkstyle.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/pmd/3.49/pmd.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/dry/2.49/dry.hpi /var/lib/jenkins/plugins/
ADD http://updates.jenkins-ci.org/download/plugins/phing/0.13.3/phing.hpi /var/lib/jenkins/plugins/

RUN chown -R jenkins:jenkins /var/lib/jenkins/plugins

ADD build.xml /usr/local/
ADD ruleset.xml /usr/share/pear/PHP/CodeSniffer/Standards/PSR2_Custom/

ENTRYPOINT service jenkins start && /bin/bash
