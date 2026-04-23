import type {Config} from '@docusaurus/types';

const config: Config = {
  title: 'Portal de Projetos',
  tagline: 'Documentação dos projetos',
  url: 'https://example.com',
  baseUrl: '/',
  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',
  i18n: {
    defaultLocale: 'pt',
    locales: ['pt'],
  },
  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: require.resolve('./sidebars.js'),
          routeBasePath: '/',
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      },
    ],
  ],
  themeConfig: {
    navbar: {
      title: 'Portal',
      items: [
        {
          type: 'dropdown',
          label: 'Projects',
          position: 'left',
          items: [
            { to: '/projects-manager-plus/', label: 'ProjectsManagerPlus' },
          ],
        },
      ],
    },
  },
};

export default config;