setup() {
    source ./src/scripts/notify.sh
    export INTRNL_SLACK_WEBHOOK="x"
}

@test "1: Skip message on no event" {
    CCI_STATUS="success"
    SLACK_PARAM_EVENT="fail"
    echo "Running notify"
    run Notify
    echo "test output status: $status"
    echo "Output:"
    echo "$output"
    echo " --- "
    [ "$status" -eq 0 ] # Check for no exit error
    [[ $output == *"NO SLACK ALERT"* ]] # Ensure output contains expected string
}
@test "2: ModifyCustomTemplate" {
    # Ensure a custom template has the text key automatically affixed.
    SLACK_PARAM_CUSTOM=$(cat $BATS_TEST_DIRNAME/sampleCustomTemplate.json)
    ModifyCustomTemplate
    TEXTKEY=$(echo $CUSTOM_BODY_MODIFIED | jq '.text')
    [ "$TEXTKEY" == '""' ]
}

@test "3: ModifyCustomTemplate with existing Text key" {
    # Ensure a custom template has the text key automatically affixed with original contents.
    SLACK_PARAM_CUSTOM=$(cat $BATS_TEST_DIRNAME/sampleCustomTemplateWithText.json)
    ModifyCustomTemplate
    TEXTKEY=$(echo $CUSTOM_BODY_MODIFIED | jq '.text')
    [ "$TEXTKEY" == '"User-Added text key"' ]
}