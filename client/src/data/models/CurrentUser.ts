export class CurrentUser {
  name!: string
  surname!: string
  login!: string
  companyId!: number
  divisionId!: number
  role: 'superadmin' | 'user' | 'companyadmin' | 'fundadmin'

  constructor(role: 'superadmin' | 'user' | 'companyadmin' | 'fundadmin') {
    this.role = role
  }
}