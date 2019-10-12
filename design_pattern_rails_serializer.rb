# use serializer to render components from a model:

# ~/profiles/show.html.erb
<%= javascript_pack_tag 'EmployeeProfile'
<%= react_component('EmployeeProfile', EmployeeProfileSerializer.new(@employee).to_h) %> >

# ~/app/serializers/employee_profile_serializer.rb
class EmployeeProfileSerializer
  attr_reader :employee

  def initialize(employee)
    @employee = employee
  end

  def to_h
    {
      id: employee.id,
      initials: employee.name.split.map { |word| word[0] }.join(''),
      educations: EducationsSerializer.new(employee.educations.where(deleted_at: nil)).to_json,
      workExperiences: WorkExperiencesSerializer.new(employee.work_experiences).to_json,
      systemsKnowledges: SkillsSerializer.new(employee.system_knowledges).to_json.pluck(:name),
      technicalSkills: SkillsSerializer.new(employee.technical_skills).to_json.pluck(:name),
      certifications: CertificationsSerializer.new(employee.certifications).to_json
    }
  end
end

# ~/app/javascript/packs/employers/EmployeeProfile.jsx
const EmployeeProfile = props => (
  <IntlProvider locale="en">
    <ThemeProvider theme={Theme}>
      <EmployeeProfileComponent
        {...props}
        avatarColor={avatarColor(props.initials)}
        educations={mapEducations(props.educations)}
      />
    </ThemeProvider>
  </IntlProvider>
);

WebpackerReact.setup({ EmployeeProfile });





