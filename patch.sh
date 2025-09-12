echo "Patching extinfo.c to show command details"
cat > cgi-patch.diff << 'EOL'
--- a/cgi/extinfo.c	2024-10-28 15:52:08.411256354 +0000
+++ b/cgi/extinfo.c	2024-10-28 15:53:06.994551441 +0000
@@ -1392,6 +1392,93 @@
 		printf("<TR><TD CLASS='dataVar'>Last Update:</TD><TD CLASS='dataVal'>%s&nbsp;&nbsp;(%s ago)</TD></TR>\n", (temp_svcstatus->last_update == (time_t)0) ? "N/A" : date_time, status_age);


+/* cesar */
+if (temp_service->check_command_ptr != NULL) {
+    char *raw_command = temp_service->check_command_ptr->command_line;
+    char *check_command = temp_service->check_command;
+    char *processed_command = NULL;
+    int result = OK;
+    int options = 0;
+
+    // Parse arguments directly from check_command by splitting on '!'
+    char *args[10] = {NULL}; // Array to hold up to 10 arguments
+    char *token = NULL;
+    int arg_index = 0;
+
+    // Duplicate check_command to safely tokenize
+    char *check_command_dup = strdup(check_command);
+    if (check_command_dup != NULL) {
+        token = strtok(check_command_dup, "!");
+        while (token != NULL && arg_index < 10) {
+            args[arg_index++] = strdup(token);
+            token = strtok(NULL, "!");
+        }
+        free(check_command_dup);
+    }
+
+    printf("<tr><td align=left valign=top class='dataVar'>\n");
+    printf("Raw Command:\n");
+    printf("</td><td align=left valign=top class='dataVal'>\n");
+    printf("%s\n",
+            (raw_command == NULL) ? "N/A" : html_encode(raw_command, FALSE));
+    printf("</td></tr>\n");
+
+    printf("<tr><td align=left valign=top class='dataVar'>\n");
+    printf("Check Command:\n");
+    printf("</td><td align=left valign=top class='dataVal'>\n");
+    printf("%s\n",
+            (check_command == NULL) ? "N/A" : html_encode(check_command, FALSE));
+    printf("</td></tr>\n");
+
+    // Create a temporary copy of raw_command for substitution
+    char *temp_command = strdup(raw_command);
+    if (temp_command != NULL) {
+        // Replace $ARGn$ placeholders with actual arguments
+        char arg_macro[10];
+        char *arg_pos;
+        for (int i = 1; i < arg_index; i++) {
+            snprintf(arg_macro, sizeof(arg_macro), "$ARG%d$", i);
+            while ((arg_pos = strstr(temp_command, arg_macro)) != NULL) {
+                char *new_command = malloc(strlen(temp_command) + strlen(args[i]) + 1);
+                if (new_command != NULL) {
+                    strncpy(new_command, temp_command, arg_pos - temp_command);
+                    new_command[arg_pos - temp_command] = '\0';
+                    strcat(new_command, args[i]);
+                    strcat(new_command, arg_pos + strlen(arg_macro));
+                    free(temp_command);
+                    temp_command = new_command;
+                }
+            }
+        }
+    }
+
+    // Now process the command with substituted arguments
+    result = process_macros_r(mac, temp_command, &processed_command, options);
+    if (result != OK) {
+        processed_command = NULL;
+    }
+
+    printf("<tr><td align=left valign=top class='dataVar'>\n");
+    printf("Processed Command:\n");
+    printf("</td><td align=left valign=top class='dataVal'>\n");
+    printf("%s\n",
+            (processed_command == NULL) ? "N/A" : html_encode(processed_command, FALSE));
+    printf("</td></tr>\n");
+
+    // Free allocated memory
+    if (processed_command != NULL)
+        free(processed_command);
+    if (temp_command != NULL)
+        free(temp_command);
+    for (int i = 0; i < 10; i++) {
+        if (args[i] != NULL)
+            free(args[i]);
+    }
+}
+/* cesar */
+
+
+
 		printf("</TABLE>\n");
 		printf("</TD></TR>\n");
 		printf("</TABLE>\n");
EOL

echo "Applying patch..."
patch -p1 < cgi-patch.diff
