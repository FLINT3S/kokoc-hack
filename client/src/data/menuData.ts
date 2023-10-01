import {type Component, h} from 'vue';
import {MenuOption, NIcon} from 'naive-ui'
import {
  CorporateFareOutlined,
  FormatListNumberedFilled,
  GroupsFilled,
  HomeFilled,
  RedeemFilled
} from "@components/icons";
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
    roles: ['companyadmin']
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
    roles: ['companyadmin']
  },
  {
    label: () =>
      h(
        RouterLink,
        {
          to: {
            path: '/employees',
          }
        },
        {default: () => 'Сотрудники'}
      ),
    key: 'employees',
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
    roles: ['employee']
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
