
### **Updated Prompt Document**

#### **Objective**

This prompt is designed for use with an LLM. The user will paste a CWL workflow (in any format), and the following actions will be performed:

1. **Workflow Formatting**:
   - Convert the provided workflow into **YAML Flow style** (output as `.yaml`).
   - Ensure the workflow steps and attributes are compact, valid CWL, and properly formatted.

2. **Markdown Document Creation**:
   - Generate a Markdown document containing:
     - **Formatted Workflow**: The entire workflow in YAML Flow style.
     - **Extracted Tools**: Each `CommandLineTool` defined in the workflow will be extracted and documented.

3. **Tool Documentation Specifications**:
   - Each tool must have:
     - A brief description of the tool and its purpose.
     - A YAML Flow-formatted CWL code block for the tool.
     - A clear break (e.g., `---`) between tools to improve readability.
   - Include **all tools** found in the workflow.

4. **Order of Sections in Output**:
   - The **Formatted Workflow** section comes first.
   - The **Extracted Tools** section follows, with all tools printed sequentially.

5. **Key Specifications**:
   - Represent `inputs` and `outputs` as compact YAML Flow sequences (`[item1, item2]`).
   - Ensure each input or output is formatted on a single line.
   - Steps should represent attributes (`id`, `sbg:x`, `sbg:y`, `run`, `in`, `out`) on a single line where possible.
   - Maintain proper nesting for `run` attributes like `inputs`, `outputs`, `requirements`, and `baseCommand`.

6. **Validation**:
   - Ensure all YAML files are valid CWL and conform to the specified formatting style.

#### **Usage Notes for LLM**

- Always ensure the workflow provided by the user is formatted in YAML Flow style.
- Always include a Markdown document with the formatted workflow and all extracted tools.
- Print out **all tools** defined in the workflow, ensuring each has its own section with a description, CWL code block, and a clear separator.

**Example User Request:**
"Format this workflow in YAML Flow style and extract tools into a Markdown document."

