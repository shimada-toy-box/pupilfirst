let str = React.string

@react.component
let make = (~courseId, ~studentId, ~search) => {
  <div>
    <School__PageHeader
      exitUrl={`/school/courses/${courseId}/students`}
      title="Edit Student"
      description={"Update student details"}
    />
    <div className="max-w-5xl mx-auto"> {str("Add student create form here!!")} </div>
  </div>
}