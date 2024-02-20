#!/bin/bash

group_id="edu.baylor.ecs.csi3471"
artifact_id="Maven-Project"
version="0.0.1-SNAPSHOT"
main_class="Main.java"

template_pom="~/skeleton-files/maven/template-pom.xml"
template_make="~/skeleton-files/maven/Makefile"

print_help() {
    echo "Usage: $0 "
    echo "[-g|--group       <group_id>]"
    echo "  This is the name of the organization that owns this project"
    echo "[-a|--artifact    <artifact_id>]"
    echo "  This is the name of the project itself"
    echo "[-v|--version     <version>]"
    echo "  This is the version number"
    echo "  Add XX-SNAPSHOT if the build is still in development"
    echo "[-m|--main-class  <main_class>]"
    echo "  This is the class that contains the 'main' method"
    echo "[-h|--help        print this menu]"
    echo "  kinda self explanatory"
    echo ""
    echo "Example Usage:"
    echo "  ./init.sh -g edu.baylor.ecs.csi3471.JonesBaylor -a lab3 -v 0.0.1-SNAPSHOT -m Main.java"
    echo "  ./init.sh --group edu.baylor.ecs --artifact My-Project"
    echo ""
    echo "Notes:"
    echo "  * This script does not support any names/variables that contain a space"
    exit 0
}

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case  "$1" in
        -g|--group) group_id="$2"; shift ;;
        -a|--artifact) artifact_id="$2"; shift ;;
        -v|--version) version="$2"; shift ;;
        -m|--main-class) main_class="$2"; shift ;;
        -h|--help) print_help ;;
        *) echo "Unknown option: $1"; exit ;;
    esac
    shift
done

# Do not accept any extra arguments (or arguments that contain a space)
if [ "$#" -gt 0 ]; then
    echo "Unexpected argument: $1"
    echo "Do not use spaces in your argument names"
    exit 1
fi

# Display the configured values
echo ""
echo "Beginning build with the following options:"
echo "Group ID: $group_id"
echo "Artifact ID: $artifact_id"
echo "Version: $version"
echo "Main Class: $main_class"
main_class_noext="${main_class%%.*}"
echo "Main Class No Extension: $main_class_noext"

while true; do
    # Prompt the user for input
    echo ""
    read -p "Do you want to continue? (y/n): " choice

    # Check if the input is 'y' or 'Y'
    if [[ $choice == "y" || $choice == "Y" ]]; then
        echo "Continuing..."
        # Continue with your script logic here
        break
    # Check if the input is 'n' or 'N'
    elif [[ $choice == "n" || $choice == "N" ]]; then
        echo "use \`./init.sh -h\` for information on how to use this script"
        echo "Exiting..."
        echo ""
        exit 1
    else
        # Invalid response, reprompt
        echo "Invalid response. Please enter 'y/Y' or 'n/N'."
    fi
done

# Generate a Maven Project
set_group="-DgroupID=$group_id"
set_artifact="-DartifactId=$artifact_id"
set_archetype="-DarchetypeArtifactId=maven-archetype-quickstart"
set_interact="-DinteractiveMode=false"

# FIX_ME: calling mvn archetype:generate does not work
# mvn archetype:generate $set_group $set_artifact $set_archetype $set_interact

# FIX_ME: but generating a makefile and calling it from there works???
# Generate Makefile to build Maven project
sed -e "s/D_GROUP_ID:=.*/D_GROUP_ID:=$group_id/g; \
        s/D_ARTIFACT_ID:=.*/D_ARTIFACT_ID:=$artifact_id/g" $template_make > Makefile
make build-mvn
rm Makefile

# Make edits to pom
sed -e "s/<groupId><!--[^<]*<\/groupId>/<groupId>${group_id}<\/groupId>/g; \
        s/<artifactId><!--[^<]*<\/artifactId>/<artifactId>${artifact_id}<\/artifactId>/g; \
        s/<version><!--[^<]*<\/version>/<version>${version}<\/version>/g; \
        s/<mainClass><!--[^<]*<\/mainClass>/<mainClass>${group_id}.${main_class_noext}<\/mainClass>/g" $template_pom > pom.xml
 
# Move final pom file into our maven project
mv pom.xml $artifact_id/pom.xml
cd $artifact_id/
mvn package
