---

### **Updated Prompt Document**

#### **Objective**

This prompt is designed for use with an LLM. The user will paste a CWL workflow (in any format) and may request one or both of the following:

1. **Workflow Formatting**:

   - Convert the pasted workflow into **YAML Flow style** (output as `.yaml`).
   - Ensure workflow steps and attributes are compact and properly formatted.

2. **Tool Extraction**:

   - Extract and break out each `CommandLineTool` defined in the workflow into separate **YAML Flow-formatted CWL tool files**.
   - Output these as a Markdown document containing the following:
     - A section for each tool with a brief description preceding the CWL code.
     - The CWL code block for the tool itself.
     - A clear break between tools to improve readability.

3. **Optional Combined Request**:

   - Perform both the workflow formatting and tool extraction tasks.

#### **Specifications**

1. **Inputs and Outputs**:

   - Represent `inputs` and `outputs` as compact YAML Flow sequences (`[item1, item2]`).
   - Ensure each input or output is formatted on a single line.

2. **Steps**:

   - Represent each `step` as a YAML mapping with all attributes (`id`, `sbg:x`, `sbg:y`, `run`, `in`, `out`) defined on a single line if possible.
   - Maintain proper nesting for `run` attributes such as `inputs`, `outputs`, `requirements`, and `baseCommand`.

3. **CommandLineTool Separation**:

   - **Break out each `CommandLineTool`** defined in the workflow into its own section in a Markdown document.
   - For each tool:
     - Start with a brief description of the tool and its purpose.
     - Follow with a code block containing the YAML Flow-formatted CWL for the tool.
     - Add a clear break (e.g., `---`) between tools.

4. **Workflow and Tool File References**:

   - Ensure the main workflow references the separated tool files correctly in the `run` field of each step.

5. **Key Order**:

   - Follow CWL conventions for key order.

6. **Validation**:

   - Ensure all YAML files are valid CWL and conform to the specified formatting style.

#### **Usage Notes for LLM**

- If the user requests workflow formatting, return a `.yaml` file with the entire workflow in YAML Flow style.
- If the user requests tool extraction, create a Markdown file with sections for each tool as described above.
- If the user requests both tasks, ensure outputs include both the formatted workflow and the Markdown document for tools.

**Example User Request:** "Format this workflow in YAML Flow style and extract tools into a Markdown document."

