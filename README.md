# activedeploy_finish

IDS pipeline extension used to complete an active deploy.
Should be used in the same pipeline stage as an _Start Active Deploy_ job.
Either completes the active deploy by ramping down the original group or rollback the deploy
based on the value of the environment variable _TEST_RESULT_FOR_AD_ by intermediate (test) jobs.
