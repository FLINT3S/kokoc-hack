import {rolesMapping} from "@data/roles.ts";

export class CurrentUser {
  id!: number
  login!: string
  role!: 'superadmin' | 'employee' | 'companyadmin' | 'fundadmin'

  employee?: {
    id: number,
    name: string,
    surname: string,
    division_id: number,
  }

  company?: {
    id: number,
    title: string
  }

  fund?: {
    id: number,
    title: string
  }

  constructor(obj: any) {
    this.id = obj.user.id
    this.login = obj.user.login

    // @ts-ignore
    this.role = rolesMapping[obj.user.role_id as number] as 'superadmin' | 'employee' | 'companyadmin' | 'fundadmin'

    if (this.role === 'employee') {
      this.employee = obj.employee;
    } else if (this.role === 'companyadmin') {
      this.company = obj.company;
    } else if (this.role === 'fundadmin') {
      this.company = obj.fund;
    }
  }

  get displayName() {
    if (this.role == 'superadmin') {
      return 'Суперадминистратор'
    } else if (this.role === 'employee') {
      return `${this?.employee?.name || ''} ${this?.employee?.surname || ''}`.trim() || 'Без имени'
    } else if (this.role === 'companyadmin') {
      return `Администратор компании ${this?.company?.title || ''}`.trim()
    } else if (this.role === 'fundadmin') {
      return `Администратор фонда ${this?.fund?.title || ''}`.trim()
    }

    return 'Без имени'
  }
}