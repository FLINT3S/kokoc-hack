import {type Component, h} from 'vue';
import {MenuOption, NIcon} from 'naive-ui'
import {
  CorporateFareOutlined,
  FormatListNumberedFilled,
  GroupsFilled,
  HomeFilled,
  RedeemFilled
} from "@vicons/material";
import {RouterLink} from "vue-router";


export function renderIcon(icon: Component) {
  return () => h(NIcon, null, {default: () => h(icon)})
}

export const menuOptions: (MenuOption & { roles: string [] })[] = [
  {
    label: () =>
      h(
        RouterLink,
        {
          to: {
            path: '/',
          }
        },
        {default: () => 'Главная'}
      ),
    key: '',
    icon: renderIcon(HomeFilled),
    roles: ['superadmin', 'employee', 'companyadmin', 'fundadmin']
  },
  {
    label: () =>
      h(
        RouterLink,
        {
          to: {
            path: '/mycompany',
          }
        },
        {default: () => 'Подразделения'}
      ),
    key: 'mycompany',
    icon: renderIcon(CorporateFareOutlined),
    roles: ['employee', 'companyadmin']
  },
  {
    label: () =>
      h(
        RouterLink,
        {
          to: {
            path: '/personal',
          }
        },
        {default: () => 'Сотрудники'}
      ),
    key: 'personal',
    icon: renderIcon(GroupsFilled),
    roles: ['superadmin', 'companyadmin']
  },
  {
    label: () =>
      h(
        RouterLink,
        {
          to: {
            path: '/leaderboard',
          }
        },
        {default: () => 'Таблица лидеров'}
      ),
    key: 'leaderboard',
    icon: renderIcon(FormatListNumberedFilled),
    roles: ['employee', 'companyadmin']
  },
  {
    label: () =>
      h(
        RouterLink,
        {
          to: {
            path: '/companies',
          }
        },
        {default: () => 'Компании'}
      ),
    key: 'companies',
    icon: renderIcon(FormatListNumberedFilled),
    roles: ['superadmin']
  },
  {
    label: () =>
      h(
        RouterLink,
        {
          to: {
            path: '/funds',
          }
        },
        {default: () => 'Фонды'}
      ),
    key: 'funds',
    icon: renderIcon(RedeemFilled),
    roles: ['superadmin', 'companyadmin']
  },
  {
    label: () =>
      h(
        RouterLink,
        {
          to: {
            path: '/myFund',
          }
        },
        {default: () => 'Мой фонд'}
      ),
    key: 'myFund',
    icon: renderIcon(RedeemFilled),
    roles: ['fundadmin']
  },
]
