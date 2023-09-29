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

  get fullName() {
    let r = ''

    if (this.name) r += this.name
    if (this.surname) r += this.surname

    return r || 'Без имени'
  }
}