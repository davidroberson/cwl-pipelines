### Prompt

Convert the following CWL provided in Seven Bridges JSON style into YAML Flow style with the following specifications:

1. **Inputs and Outputs**:
   - Represent `inputs` and `outputs` as compact YAML Flow sequences (`[item1, item2]`).
   - Ensure each input or output is formatted on a single line.

2. **Steps**:
   - Represent each `step` as a YAML mapping with all attributes (`id`, `sbg:x`, `sbg:y`, `run`, `in`, `out`) defined in a single line if possible.
   - Maintain proper nesting for `run` attributes such as `inputs`, `outputs`, `requirements`, and `baseCommand`.
   - Include `in` and `out` fields on the same line with their respective connections.

3. **Attribute Quoting**:
   - Quote complex data types like `File[]?` or strings containing special characters (e.g., `--prefix`) to prevent validation errors.

4. **Key Order**:
   - Follow CWL conventions for key order, such as `id`, `type`, `doc`, and `secondaryFiles` for inputs, and `id`, `run`, `in`, `out` for steps.

5. **Namespaces**:
   - Include `$namespaces` with the `sbg` namespace as a mapping.

6. **Requirements**:
   - Represent requirements compactly as a YAML sequence.

#### Example Conversion:

**Input (JSON):**
```json
{
  "class": "Workflow",
  "cwlVersion": "v1.2",
  "inputs": [
    { "id": "gvcfs", "type": "File[]?", "doc": "List of GVCF files", "secondaryFiles": [{ "pattern": ".tbi", "required": true }] }
  ],
  "outputs": [
    { "id": "vds_files", "type": "File[]", "doc": "Generated VDS files" }
  ],
  "steps": {
    "gvcf_to_vds": {
      "run": {
        "class": "CommandLineTool",
        "inputs": { "gvcfs": { "type": "File[]?", "inputBinding": { "prefix": "--gvcf-paths" } } },
        "outputs": { "vds_files": { "type": "File[]" } }
      },
      "in": { "gvcfs": "gvcfs" },
      "out": ["vds_files"]
    }
  }
}
```
  
**Output (YAML Flow Style):**  
  
```yaml
class: Workflow
cwlVersion: v1.2
$namespaces: {sbg: "https://sevenbridges.com"}
inputs: [{id: gvcfs, type: "File[]?", doc: "List of GVCF files", secondaryFiles: [{pattern: ".tbi", required: true}]}]
outputs: [{id: vds_files, type: "File[]", doc: "Generated VDS files"}]
steps: {
  gvcf_to_vds: {id: gvcf_to_vds, run: {class: CommandLineTool, inputs: {gvcfs: {type: "File[]?", inputBinding: {prefix: "--gvcf-paths"}}}, outputs: {vds_files: {type: "File[]"}}}, in: {gvcfs: gvcfs}, out: [vds_files]}
}
```
  
Please process the CWL JSON below following these guidelines and convert it to the YAML Flow style format.

