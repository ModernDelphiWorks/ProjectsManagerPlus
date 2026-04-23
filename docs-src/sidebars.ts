export default {
  docsSidebar: [
    { type: 'doc', id: 'intro' },
    {
      type: 'category',
      label: 'Projects',
      items: [
        { type: 'link', label: 'ProjectsManagerPlus', href: '/projects-manager-plus/' }
      ]
    }
  ],
  projectsManagerPlusSidebar: [
    {
      type: 'category',
      label: 'ProjectsManagerPlus',
      link: { type: 'doc', id: 'projects-manager-plus/index' },
      items: [
        'projects-manager-plus/introduction',
        {
          type: 'category',
          label: 'Getting Started',
          items: ['projects-manager-plus/getting-started/quickstart'],
        },
        {
          type: 'category',
          label: 'Architecture',
          items: [
            'projects-manager-plus/architecture/overview',
            'projects-manager-plus/architecture/runtime-flow'
          ],
        },
        {
          type: 'category',
          label: 'Reference',
          items: ['projects-manager-plus/reference/api'],
        },
        {
          type: 'category',
          label: 'Tests & Support',
          items: [
            'projects-manager-plus/tests/overview',
            'projects-manager-plus/troubleshooting/common-errors'
          ],
        },
      ],
    },
  ],
};