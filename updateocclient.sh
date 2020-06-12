#!/bin/bash
# Run script with ./updateocclient.sh 4.x.x to install that 
# version of oc and openshift-install
# e.g. $ ./updateocclient.sh 4.3.23

VERSION=$1
CUR_VERSION=$(oc version 2>/dev/null | grep Client | sed -e 's/Client Version: //')

if [ "$VERSION" == "$CUR_VERSION" ]; then
	echo "Requested $VERSION is already installed."
	exit
else
	wget -q https://mirror.openshift.com/pub/openshift-v4/clients/ocp/$VERSION/openshift-client-linux-$VERSION.tar.gz -O /tmp/openshift-client-linux.tar.gz
	wget -q https://mirror.openshift.com/pub/openshift-v4/clients/ocp/$VERSION/openshift-install-linux-$VERSION.tar.gz -O /tmp/openshift-install-linux.tar.gz

fi

if [[ -f "/usr/local/bin/oc" ]] && [[ -f "/usr/local/bin/openshift-install" ]] && [[ -f "/usr/local/bin/kubectl" ]]
then
    for i in openshift-install oc kubectl; do mv "$(which $i)" /usr/local/bin/"$i"."$CUR_VERSION".bak; done
fi

tar -zxf /tmp/openshift-client-linux.tar.gz -C /usr/local/bin
tar -zxf /tmp/openshift-install-linux.tar.gz -C /usr/local/bin

rm -rf /usr/local/bin/README.md

rm -rf /tmp/openshift-client-linux.tar.gz
rm -rf /tmp/openshift-install-linux.tar.gz

if which oc &>/dev/null; then
    echo -e "\noc version: $(oc version 2>/dev/null | grep Client | sed -e 's/Client Version: //')"
else
    echo "Error getting oc version."
fi

if which kubectl &>/dev/null; then
    echo -e "\nkubectl version: $(kubectl version --client | grep -o "GitVersion:.*" | cut -d, -f1)"
else
    echo "Error getting kubectl version."
fi

if which openshift-install &>/dev/null; then
    echo -e "\nopenshift-install version: $(openshift-install version | grep openshift-install | sed -e 's/openshift-install //')"
else
    echo "Error getting openshift-install version."
fi
