/****** Object:  Table [dbo].[CompanyInvitationToken]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyInvitationToken](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_id] [bigint] NOT NULL,
	[token] [nvarchar](64) NOT NULL,
	[created_at] [datetimeoffset](7) NOT NULL,
	[expires_at] [datetimeoffset](7) NOT NULL,
	[company_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[user_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[token] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_candidato]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_candidato](
	[id_candidato_id] [int] NOT NULL,
	[rut_candidato] [nvarchar](15) NOT NULL,
	[fecha_nacimiento] [date] NOT NULL,
	[telefono] [nvarchar](20) NOT NULL,
	[disponible] [bit] NOT NULL,
	[linkedin_url] [nvarchar](255) NULL,
	[ciudad_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_candidato_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_categoria]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_categoria](
	[id_categoria] [int] IDENTITY(1,1) NOT NULL,
	[tipo_categoria] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_categoria] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_certificacionescv]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_certificacionescv](
	[id_certificacion] [int] IDENTITY(1,1) NOT NULL,
	[nombre_certificacion] [nvarchar](150) NOT NULL,
	[entidad_emisora] [nvarchar](150) NOT NULL,
	[fecha_obtencion] [date] NOT NULL,
	[cv_creado_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_certificacion] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_ciudad]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_ciudad](
	[id_ciudad] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](100) NOT NULL,
	[region_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_ciudad] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_cvcandidato]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_cvcandidato](
	[id_cv_user] [int] IDENTITY(1,1) NOT NULL,
	[nombre_cv] [nvarchar](100) NOT NULL,
	[cargo_asociado] [nvarchar](100) NOT NULL,
	[tipo_cv] [nvarchar](20) NOT NULL,
	[candidato_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_cv_user] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_cvcreado]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_cvcreado](
	[id_cv_creado_id] [int] NOT NULL,
	[fecha_creacion] [datetimeoffset](7) NOT NULL,
	[ultima_actualizacion] [datetimeoffset](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_cv_creado_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_cvsubido]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_cvsubido](
	[id_cv_subido_id] [int] NOT NULL,
	[fecha_subido] [datetimeoffset](7) NOT NULL,
	[ruta_archivo] [nvarchar](500) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_cv_subido_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_datospersonalescv]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_datospersonalescv](
	[id_cv_creado_id] [int] NOT NULL,
	[primer_nombre] [nvarchar](50) NOT NULL,
	[segundo_nombre] [nvarchar](50) NULL,
	[apellido_paterno] [nvarchar](50) NOT NULL,
	[apellido_materno] [nvarchar](50) NULL,
	[titulo_profesional] [nvarchar](100) NULL,
	[email] [nvarchar](150) NOT NULL,
	[telefono] [nvarchar](20) NOT NULL,
	[linkedin] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_cv_creado_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_educacioncv]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_educacioncv](
	[id_educacion] [int] IDENTITY(1,1) NOT NULL,
	[institucion] [nvarchar](100) NOT NULL,
	[carrera_titulo_nivel] [nvarchar](100) NOT NULL,
	[fecha_inicio] [date] NOT NULL,
	[fecha_termino] [date] NULL,
	[cursando] [bit] NOT NULL,
	[comentarios] [nvarchar](500) NULL,
	[cv_creado_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_educacion] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_empresa]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_empresa](
	[id_empresa] [int] IDENTITY(1,1) NOT NULL,
	[rut_empresa] [nvarchar](20) NOT NULL,
	[razon_social] [nvarchar](150) NOT NULL,
	[nombre_comercial] [nvarchar](150) NOT NULL,
	[resumen_empresa] [nvarchar](max) NOT NULL,
	[mision] [nvarchar](max) NULL,
	[vision] [nvarchar](max) NULL,
	[telefono] [nvarchar](20) NOT NULL,
	[sitio_web] [nvarchar](255) NULL,
	[imagen_portada] [nvarchar](500) NULL,
	[imagen_perfil] [nvarchar](500) NULL,
	[ultima_modificacion] [datetimeoffset](7) NOT NULL,
	[rubro_id] [int] NULL,
	[ciudad_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_empresa] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[rut_empresa] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_empresausuario]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_empresausuario](
	[id_empresa_user_id] [int] NOT NULL,
	[empresa_id] [int] NOT NULL,
	[rol_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_empresa_user_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_entrevista]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_entrevista](
	[id_entrevista] [int] IDENTITY(1,1) NOT NULL,
	[fecha_entrevista] [date] NOT NULL,
	[hora_entrevista] [time](7) NOT NULL,
	[nombre_reclutador] [nvarchar](150) NOT NULL,
	[modalidad] [nvarchar](20) NOT NULL,
	[asistencia_confirmada] [bit] NULL,
	[postulacion_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_entrevista] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_experiencialaboralcv]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_experiencialaboralcv](
	[id_experiencia] [int] IDENTITY(1,1) NOT NULL,
	[cargo_puesto] [nvarchar](100) NOT NULL,
	[empresa] [nvarchar](100) NOT NULL,
	[ubicacion] [nvarchar](100) NOT NULL,
	[fecha_inicio] [date] NOT NULL,
	[fecha_termino] [date] NULL,
	[trabajo_actual] [bit] NOT NULL,
	[practica] [bit] NOT NULL,
	[horas_practica] [int] NULL,
	[descripcion_cargo] [nvarchar](max) NOT NULL,
	[cv_creado_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_experiencia] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_habilidadcv]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_habilidadcv](
	[id_habilidad] [int] IDENTITY(1,1) NOT NULL,
	[tipo_habilidad] [nvarchar](50) NOT NULL,
	[texto_habilidad] [nvarchar](150) NOT NULL,
	[cv_creado_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_habilidad] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_idiomacv]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_idiomacv](
	[id_idioma] [int] IDENTITY(1,1) NOT NULL,
	[nombre_idioma] [nvarchar](50) NOT NULL,
	[nivel_idioma] [nvarchar](30) NOT NULL,
	[cv_creado_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_idioma] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_jornada]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_jornada](
	[id_jornada] [int] IDENTITY(1,1) NOT NULL,
	[tipo_jornada] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_jornada] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_modalidad]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_modalidad](
	[id_modalidad] [int] IDENTITY(1,1) NOT NULL,
	[tipo_modalidad] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_modalidad] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_modoonline]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_modoonline](
	[id_modo_online_id] [int] NOT NULL,
	[plataforma] [nvarchar](100) NOT NULL,
	[url_reunion] [nvarchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_modo_online_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_modopresencial]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_modopresencial](
	[id_modo_presencial_id] [int] NOT NULL,
	[direccion] [nvarchar](150) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_modo_presencial_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_notificacioncandidato]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_notificacioncandidato](
	[id_notificacion_candidato_id] [int] NOT NULL,
	[motivo] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_notificacion_candidato_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_notificacionempresa]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_notificacionempresa](
	[id_notificacion_empresa_id] [int] NOT NULL,
	[motivo] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_notificacion_empresa_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_notificaciones]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_notificaciones](
	[id_notificacion] [int] IDENTITY(1,1) NOT NULL,
	[mensaje] [nvarchar](255) NOT NULL,
	[fecha_envio] [datetimeoffset](7) NOT NULL,
	[leida] [bit] NOT NULL,
	[link_relacionado] [nvarchar](255) NULL,
	[usuario_destino_id] [int] NOT NULL,
	[tipo_notificacion_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_notificacion] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_objetivoprofesionalcv]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_objetivoprofesionalcv](
	[id_cv_creado_id] [int] NOT NULL,
	[texto_objetivo] [nvarchar](max) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_cv_creado_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_ofertalaboral]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_ofertalaboral](
	[id_oferta] [int] IDENTITY(1,1) NOT NULL,
	[titulo_puesto] [nvarchar](150) NOT NULL,
	[descripcion_puesto] [nvarchar](max) NOT NULL,
	[requisitos_puesto] [nvarchar](max) NOT NULL,
	[habilidades_clave] [nvarchar](500) NULL,
	[beneficios] [nvarchar](500) NULL,
	[nivel_experiencia] [nvarchar](50) NOT NULL,
	[salario_min] [int] NOT NULL,
	[salario_max] [int] NOT NULL,
	[fecha_publicacion] [date] NOT NULL,
	[fecha_cierre] [date] NOT NULL,
	[categoria_id] [int] NULL,
	[empresa_id] [int] NOT NULL,
	[jornada_id] [int] NULL,
	[modalidad_id] [int] NULL,
	[estado] [nvarchar](10) NOT NULL,
	[ciudad_id] [int] NULL,
	[vistas] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_oferta] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_postulacion]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_postulacion](
	[id_postulacion] [int] IDENTITY(1,1) NOT NULL,
	[fecha_postulacion] [datetimeoffset](7) NOT NULL,
	[estado_postulacion] [nvarchar](50) NOT NULL,
	[candidato_id] [int] NOT NULL,
	[cv_postulado_id] [int] NOT NULL,
	[oferta_id] [int] NOT NULL,
	[cv_visto] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_postulacion] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_proyectoscv]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_proyectoscv](
	[id_proyecto] [int] IDENTITY(1,1) NOT NULL,
	[nombre_proyecto] [nvarchar](100) NOT NULL,
	[fecha_proyecto] [date] NOT NULL,
	[rol_participacion] [nvarchar](100) NULL,
	[descripcion_proyecto] [nvarchar](max) NOT NULL,
	[url_proyecto] [nvarchar](255) NULL,
	[cv_creado_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_proyecto] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_referenciascv]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_referenciascv](
	[id_referencia] [int] IDENTITY(1,1) NOT NULL,
	[nombre_referente] [nvarchar](100) NOT NULL,
	[cargo_referente] [nvarchar](100) NOT NULL,
	[telefono] [nvarchar](20) NOT NULL,
	[email] [nvarchar](150) NOT NULL,
	[url_linkedin] [nvarchar](255) NULL,
	[cv_creado_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_referencia] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_region]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_region](
	[id_region] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_region] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[nombre] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_registrousuarios]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_registrousuarios](
	[id_registro_id] [int] NOT NULL,
	[email] [nvarchar](100) NOT NULL,
	[contrasena] [nvarchar](255) NOT NULL,
	[fecha_creacion] [datetimeoffset](7) NOT NULL,
	[activo] [bit] NOT NULL,
	[ultimo_ingreso] [datetimeoffset](7) NULL,
	[tipo_usuario_id] [int] NULL,
	[apellidos] [nvarchar](100) NOT NULL,
	[nombres] [nvarchar](100) NOT NULL,
	[autenticacion_dos_factores_activa] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_registro_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_rolesempresa]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_rolesempresa](
	[id_rol] [int] IDENTITY(1,1) NOT NULL,
	[nombre_rol] [nvarchar](50) NOT NULL,
	[descripcion_rol] [nvarchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_rol] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_rubroindustria]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_rubroindustria](
	[id_rubro] [int] IDENTITY(1,1) NOT NULL,
	[nombre_rubro] [nvarchar](50) NOT NULL,
	[descripcion_rubro] [nvarchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_rubro] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_tiponotificacion]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_tiponotificacion](
	[id_tipo_notificacion] [int] IDENTITY(1,1) NOT NULL,
	[nombre_tipo] [nvarchar](50) NOT NULL,
	[descripcion] [nvarchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_tipo_notificacion] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_tipousuario]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_tipousuario](
	[id_tipo_user] [int] IDENTITY(1,1) NOT NULL,
	[nombre_user] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_tipo_user] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JFlex_voluntariadocv]    Script Date: 25-11-2025 0:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JFlex_voluntariadocv](
	[id_voluntariado] [int] IDENTITY(1,1) NOT NULL,
	[nombre_organizacion] [nvarchar](100) NOT NULL,
	[puesto_rol] [nvarchar](100) NOT NULL,
	[descripcion_actividades] [nvarchar](max) NOT NULL,
	[ciudad] [nvarchar](50) NOT NULL,
	[region_estado_provincia] [nvarchar](50) NULL,
	[pais] [nvarchar](50) NOT NULL,
	[fecha_inicio] [date] NOT NULL,
	[fecha_termino] [date] NULL,
	[actualmente_activo] [bit] NOT NULL,
	[cv_creado_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_voluntariado] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[JFlex_ofertalaboral] ADD  DEFAULT ('activa') FOR [estado]
GO
ALTER TABLE [dbo].[CompanyInvitationToken]  WITH CHECK ADD  CONSTRAINT [CompanyInvitationToken_company_id_54961a30_fk_JFlex_empresa_id_empresa] FOREIGN KEY([company_id])
REFERENCES [dbo].[JFlex_empresa] ([id_empresa])
GO
ALTER TABLE [dbo].[CompanyInvitationToken] CHECK CONSTRAINT [CompanyInvitationToken_company_id_54961a30_fk_JFlex_empresa_id_empresa]
GO
ALTER TABLE [dbo].[JFlex_candidato]  WITH CHECK ADD  CONSTRAINT [JFlex_candidato_ciudad_id_a58d2e8d_fk_JFlex_ciudad_id_ciudad] FOREIGN KEY([ciudad_id])
REFERENCES [dbo].[JFlex_ciudad] ([id_ciudad])
GO
ALTER TABLE [dbo].[JFlex_candidato] CHECK CONSTRAINT [JFlex_candidato_ciudad_id_a58d2e8d_fk_JFlex_ciudad_id_ciudad]
GO
ALTER TABLE [dbo].[JFlex_certificacionescv]  WITH CHECK ADD  CONSTRAINT [JFlex_certificacionescv_cv_creado_id_3e824045_fk_JFlex_cvcreado_id_cv_creado_id] FOREIGN KEY([cv_creado_id])
REFERENCES [dbo].[JFlex_cvcreado] ([id_cv_creado_id])
GO
ALTER TABLE [dbo].[JFlex_certificacionescv] CHECK CONSTRAINT [JFlex_certificacionescv_cv_creado_id_3e824045_fk_JFlex_cvcreado_id_cv_creado_id]
GO
ALTER TABLE [dbo].[JFlex_ciudad]  WITH CHECK ADD  CONSTRAINT [JFlex_ciudad_region_id_de7fa2f2_fk_JFlex_region_id_region] FOREIGN KEY([region_id])
REFERENCES [dbo].[JFlex_region] ([id_region])
GO
ALTER TABLE [dbo].[JFlex_ciudad] CHECK CONSTRAINT [JFlex_ciudad_region_id_de7fa2f2_fk_JFlex_region_id_region]
GO
ALTER TABLE [dbo].[JFlex_cvcandidato]  WITH CHECK ADD  CONSTRAINT [JFlex_cvcandidato_candidato_id_dab578a4_fk_JFlex_candidato_id_candidato_id] FOREIGN KEY([candidato_id])
REFERENCES [dbo].[JFlex_candidato] ([id_candidato_id])
GO
ALTER TABLE [dbo].[JFlex_cvcandidato] CHECK CONSTRAINT [JFlex_cvcandidato_candidato_id_dab578a4_fk_JFlex_candidato_id_candidato_id]
GO
ALTER TABLE [dbo].[JFlex_cvcreado]  WITH CHECK ADD  CONSTRAINT [JFlex_cvcreado_id_cv_creado_id_677f85b3_fk_JFlex_cvcandidato_id_cv_user] FOREIGN KEY([id_cv_creado_id])
REFERENCES [dbo].[JFlex_cvcandidato] ([id_cv_user])
GO
ALTER TABLE [dbo].[JFlex_cvcreado] CHECK CONSTRAINT [JFlex_cvcreado_id_cv_creado_id_677f85b3_fk_JFlex_cvcandidato_id_cv_user]
GO
ALTER TABLE [dbo].[JFlex_cvsubido]  WITH CHECK ADD  CONSTRAINT [JFlex_cvsubido_id_cv_subido_id_4ddbdcae_fk_JFlex_cvcandidato_id_cv_user] FOREIGN KEY([id_cv_subido_id])
REFERENCES [dbo].[JFlex_cvcandidato] ([id_cv_user])
GO
ALTER TABLE [dbo].[JFlex_cvsubido] CHECK CONSTRAINT [JFlex_cvsubido_id_cv_subido_id_4ddbdcae_fk_JFlex_cvcandidato_id_cv_user]
GO
ALTER TABLE [dbo].[JFlex_datospersonalescv]  WITH CHECK ADD  CONSTRAINT [JFlex_datospersonalescv_id_cv_creado_id_8beea778_fk_JFlex_cvcreado_id_cv_creado_id] FOREIGN KEY([id_cv_creado_id])
REFERENCES [dbo].[JFlex_cvcreado] ([id_cv_creado_id])
GO
ALTER TABLE [dbo].[JFlex_datospersonalescv] CHECK CONSTRAINT [JFlex_datospersonalescv_id_cv_creado_id_8beea778_fk_JFlex_cvcreado_id_cv_creado_id]
GO
ALTER TABLE [dbo].[JFlex_educacioncv]  WITH CHECK ADD  CONSTRAINT [JFlex_educacioncv_cv_creado_id_e5fd2ee3_fk_JFlex_cvcreado_id_cv_creado_id] FOREIGN KEY([cv_creado_id])
REFERENCES [dbo].[JFlex_cvcreado] ([id_cv_creado_id])
GO
ALTER TABLE [dbo].[JFlex_educacioncv] CHECK CONSTRAINT [JFlex_educacioncv_cv_creado_id_e5fd2ee3_fk_JFlex_cvcreado_id_cv_creado_id]
GO
ALTER TABLE [dbo].[JFlex_empresa]  WITH CHECK ADD  CONSTRAINT [JFlex_empresa_ciudad_id_d486926d_fk_JFlex_ciudad_id_ciudad] FOREIGN KEY([ciudad_id])
REFERENCES [dbo].[JFlex_ciudad] ([id_ciudad])
GO
ALTER TABLE [dbo].[JFlex_empresa] CHECK CONSTRAINT [JFlex_empresa_ciudad_id_d486926d_fk_JFlex_ciudad_id_ciudad]
GO
ALTER TABLE [dbo].[JFlex_empresa]  WITH CHECK ADD  CONSTRAINT [JFlex_empresa_rubro_id_088912e6_fk_JFlex_rubroindustria_id_rubro] FOREIGN KEY([rubro_id])
REFERENCES [dbo].[JFlex_rubroindustria] ([id_rubro])
GO
ALTER TABLE [dbo].[JFlex_empresa] CHECK CONSTRAINT [JFlex_empresa_rubro_id_088912e6_fk_JFlex_rubroindustria_id_rubro]
GO
ALTER TABLE [dbo].[JFlex_empresausuario]  WITH CHECK ADD  CONSTRAINT [JFlex_empresausuario_empresa_id_eeb85cf2_fk_JFlex_empresa_id_empresa] FOREIGN KEY([empresa_id])
REFERENCES [dbo].[JFlex_empresa] ([id_empresa])
GO
ALTER TABLE [dbo].[JFlex_empresausuario] CHECK CONSTRAINT [JFlex_empresausuario_empresa_id_eeb85cf2_fk_JFlex_empresa_id_empresa]
GO
ALTER TABLE [dbo].[JFlex_empresausuario]  WITH CHECK ADD  CONSTRAINT [JFlex_empresausuario_rol_id_105cc415_fk_JFlex_rolesempresa_id_rol] FOREIGN KEY([rol_id])
REFERENCES [dbo].[JFlex_rolesempresa] ([id_rol])
GO
ALTER TABLE [dbo].[JFlex_empresausuario] CHECK CONSTRAINT [JFlex_empresausuario_rol_id_105cc415_fk_JFlex_rolesempresa_id_rol]
GO
ALTER TABLE [dbo].[JFlex_entrevista]  WITH CHECK ADD  CONSTRAINT [JFlex_entrevista_postulacion_id_4d091cd0_fk_JFlex_postulacion_id_postulacion] FOREIGN KEY([postulacion_id])
REFERENCES [dbo].[JFlex_postulacion] ([id_postulacion])
GO
ALTER TABLE [dbo].[JFlex_entrevista] CHECK CONSTRAINT [JFlex_entrevista_postulacion_id_4d091cd0_fk_JFlex_postulacion_id_postulacion]
GO
ALTER TABLE [dbo].[JFlex_experiencialaboralcv]  WITH CHECK ADD  CONSTRAINT [JFlex_experiencialaboralcv_cv_creado_id_d63084e5_fk_JFlex_cvcreado_id_cv_creado_id] FOREIGN KEY([cv_creado_id])
REFERENCES [dbo].[JFlex_cvcreado] ([id_cv_creado_id])
GO
ALTER TABLE [dbo].[JFlex_experiencialaboralcv] CHECK CONSTRAINT [JFlex_experiencialaboralcv_cv_creado_id_d63084e5_fk_JFlex_cvcreado_id_cv_creado_id]
GO
ALTER TABLE [dbo].[JFlex_habilidadcv]  WITH CHECK ADD  CONSTRAINT [JFlex_habilidadcv_cv_creado_id_244d6caf_fk_JFlex_cvcreado_id_cv_creado_id] FOREIGN KEY([cv_creado_id])
REFERENCES [dbo].[JFlex_cvcreado] ([id_cv_creado_id])
GO
ALTER TABLE [dbo].[JFlex_habilidadcv] CHECK CONSTRAINT [JFlex_habilidadcv_cv_creado_id_244d6caf_fk_JFlex_cvcreado_id_cv_creado_id]
GO
ALTER TABLE [dbo].[JFlex_idiomacv]  WITH CHECK ADD  CONSTRAINT [JFlex_idiomacv_cv_creado_id_a8512324_fk_JFlex_cvcreado_id_cv_creado_id] FOREIGN KEY([cv_creado_id])
REFERENCES [dbo].[JFlex_cvcreado] ([id_cv_creado_id])
GO
ALTER TABLE [dbo].[JFlex_idiomacv] CHECK CONSTRAINT [JFlex_idiomacv_cv_creado_id_a8512324_fk_JFlex_cvcreado_id_cv_creado_id]
GO
ALTER TABLE [dbo].[JFlex_modoonline]  WITH CHECK ADD  CONSTRAINT [JFlex_modoonline_id_modo_online_id_1a6e1537_fk_JFlex_entrevista_id_entrevista] FOREIGN KEY([id_modo_online_id])
REFERENCES [dbo].[JFlex_entrevista] ([id_entrevista])
GO
ALTER TABLE [dbo].[JFlex_modoonline] CHECK CONSTRAINT [JFlex_modoonline_id_modo_online_id_1a6e1537_fk_JFlex_entrevista_id_entrevista]
GO
ALTER TABLE [dbo].[JFlex_modopresencial]  WITH CHECK ADD  CONSTRAINT [JFlex_modopresencial_id_modo_presencial_id_1a8d9593_fk_JFlex_entrevista_id_entrevista] FOREIGN KEY([id_modo_presencial_id])
REFERENCES [dbo].[JFlex_entrevista] ([id_entrevista])
GO
ALTER TABLE [dbo].[JFlex_modopresencial] CHECK CONSTRAINT [JFlex_modopresencial_id_modo_presencial_id_1a8d9593_fk_JFlex_entrevista_id_entrevista]
GO
ALTER TABLE [dbo].[JFlex_notificacioncandidato]  WITH CHECK ADD  CONSTRAINT [JFlex_notificacioncandidato_id_notificacion_candidato_id_0f700e88_fk_JFlex_notificaciones_id_notificacion] FOREIGN KEY([id_notificacion_candidato_id])
REFERENCES [dbo].[JFlex_notificaciones] ([id_notificacion])
GO
ALTER TABLE [dbo].[JFlex_notificacioncandidato] CHECK CONSTRAINT [JFlex_notificacioncandidato_id_notificacion_candidato_id_0f700e88_fk_JFlex_notificaciones_id_notificacion]
GO
ALTER TABLE [dbo].[JFlex_notificacionempresa]  WITH CHECK ADD  CONSTRAINT [JFlex_notificacionempresa_id_notificacion_empresa_id_60426407_fk_JFlex_notificaciones_id_notificacion] FOREIGN KEY([id_notificacion_empresa_id])
REFERENCES [dbo].[JFlex_notificaciones] ([id_notificacion])
GO
ALTER TABLE [dbo].[JFlex_notificacionempresa] CHECK CONSTRAINT [JFlex_notificacionempresa_id_notificacion_empresa_id_60426407_fk_JFlex_notificaciones_id_notificacion]
GO
ALTER TABLE [dbo].[JFlex_notificaciones]  WITH CHECK ADD  CONSTRAINT [JFlex_notificaciones_tipo_notificacion_id_d2ae0477_fk_JFlex_tiponotificacion_id_tipo_notificacion] FOREIGN KEY([tipo_notificacion_id])
REFERENCES [dbo].[JFlex_tiponotificacion] ([id_tipo_notificacion])
GO
ALTER TABLE [dbo].[JFlex_notificaciones] CHECK CONSTRAINT [JFlex_notificaciones_tipo_notificacion_id_d2ae0477_fk_JFlex_tiponotificacion_id_tipo_notificacion]
GO
ALTER TABLE [dbo].[JFlex_objetivoprofesionalcv]  WITH CHECK ADD  CONSTRAINT [JFlex_objetivoprofesionalcv_id_cv_creado_id_8e3a2997_fk_JFlex_cvcreado_id_cv_creado_id] FOREIGN KEY([id_cv_creado_id])
REFERENCES [dbo].[JFlex_cvcreado] ([id_cv_creado_id])
GO
ALTER TABLE [dbo].[JFlex_objetivoprofesionalcv] CHECK CONSTRAINT [JFlex_objetivoprofesionalcv_id_cv_creado_id_8e3a2997_fk_JFlex_cvcreado_id_cv_creado_id]
GO
ALTER TABLE [dbo].[JFlex_ofertalaboral]  WITH CHECK ADD  CONSTRAINT [JFlex_ofertalaboral_categoria_id_a39cec13_fk_JFlex_categoria_id_categoria] FOREIGN KEY([categoria_id])
REFERENCES [dbo].[JFlex_categoria] ([id_categoria])
GO
ALTER TABLE [dbo].[JFlex_ofertalaboral] CHECK CONSTRAINT [JFlex_ofertalaboral_categoria_id_a39cec13_fk_JFlex_categoria_id_categoria]
GO
ALTER TABLE [dbo].[JFlex_ofertalaboral]  WITH CHECK ADD  CONSTRAINT [JFlex_ofertalaboral_ciudad_id_08cd86eb_fk_JFlex_ciudad_id_ciudad] FOREIGN KEY([ciudad_id])
REFERENCES [dbo].[JFlex_ciudad] ([id_ciudad])
GO
ALTER TABLE [dbo].[JFlex_ofertalaboral] CHECK CONSTRAINT [JFlex_ofertalaboral_ciudad_id_08cd86eb_fk_JFlex_ciudad_id_ciudad]
GO
ALTER TABLE [dbo].[JFlex_ofertalaboral]  WITH CHECK ADD  CONSTRAINT [JFlex_ofertalaboral_empresa_id_07c1cc82_fk_JFlex_empresa_id_empresa] FOREIGN KEY([empresa_id])
REFERENCES [dbo].[JFlex_empresa] ([id_empresa])
GO
ALTER TABLE [dbo].[JFlex_ofertalaboral] CHECK CONSTRAINT [JFlex_ofertalaboral_empresa_id_07c1cc82_fk_JFlex_empresa_id_empresa]
GO
ALTER TABLE [dbo].[JFlex_ofertalaboral]  WITH CHECK ADD  CONSTRAINT [JFlex_ofertalaboral_jornada_id_2208447e_fk_JFlex_jornada_id_jornada] FOREIGN KEY([jornada_id])
REFERENCES [dbo].[JFlex_jornada] ([id_jornada])
GO
ALTER TABLE [dbo].[JFlex_ofertalaboral] CHECK CONSTRAINT [JFlex_ofertalaboral_jornada_id_2208447e_fk_JFlex_jornada_id_jornada]
GO
ALTER TABLE [dbo].[JFlex_ofertalaboral]  WITH CHECK ADD  CONSTRAINT [JFlex_ofertalaboral_modalidad_id_f50fe3c7_fk_JFlex_modalidad_id_modalidad] FOREIGN KEY([modalidad_id])
REFERENCES [dbo].[JFlex_modalidad] ([id_modalidad])
GO
ALTER TABLE [dbo].[JFlex_ofertalaboral] CHECK CONSTRAINT [JFlex_ofertalaboral_modalidad_id_f50fe3c7_fk_JFlex_modalidad_id_modalidad]
GO
ALTER TABLE [dbo].[JFlex_postulacion]  WITH CHECK ADD  CONSTRAINT [JFlex_postulacion_candidato_id_088175c4_fk_JFlex_candidato_id_candidato_id] FOREIGN KEY([candidato_id])
REFERENCES [dbo].[JFlex_candidato] ([id_candidato_id])
GO
ALTER TABLE [dbo].[JFlex_postulacion] CHECK CONSTRAINT [JFlex_postulacion_candidato_id_088175c4_fk_JFlex_candidato_id_candidato_id]
GO
ALTER TABLE [dbo].[JFlex_postulacion]  WITH CHECK ADD  CONSTRAINT [JFlex_postulacion_cv_postulado_id_9e95c7db_fk_JFlex_cvcandidato_id_cv_user] FOREIGN KEY([cv_postulado_id])
REFERENCES [dbo].[JFlex_cvcandidato] ([id_cv_user])
GO
ALTER TABLE [dbo].[JFlex_postulacion] CHECK CONSTRAINT [JFlex_postulacion_cv_postulado_id_9e95c7db_fk_JFlex_cvcandidato_id_cv_user]
GO
ALTER TABLE [dbo].[JFlex_postulacion]  WITH CHECK ADD  CONSTRAINT [JFlex_postulacion_oferta_id_22674a31_fk_JFlex_ofertalaboral_id_oferta] FOREIGN KEY([oferta_id])
REFERENCES [dbo].[JFlex_ofertalaboral] ([id_oferta])
GO
ALTER TABLE [dbo].[JFlex_postulacion] CHECK CONSTRAINT [JFlex_postulacion_oferta_id_22674a31_fk_JFlex_ofertalaboral_id_oferta]
GO
ALTER TABLE [dbo].[JFlex_proyectoscv]  WITH CHECK ADD  CONSTRAINT [JFlex_proyectoscv_cv_creado_id_387dfe01_fk_JFlex_cvcreado_id_cv_creado_id] FOREIGN KEY([cv_creado_id])
REFERENCES [dbo].[JFlex_cvcreado] ([id_cv_creado_id])
GO
ALTER TABLE [dbo].[JFlex_proyectoscv] CHECK CONSTRAINT [JFlex_proyectoscv_cv_creado_id_387dfe01_fk_JFlex_cvcreado_id_cv_creado_id]
GO
ALTER TABLE [dbo].[JFlex_referenciascv]  WITH CHECK ADD  CONSTRAINT [JFlex_referenciascv_cv_creado_id_6cb0d15d_fk_JFlex_cvcreado_id_cv_creado_id] FOREIGN KEY([cv_creado_id])
REFERENCES [dbo].[JFlex_cvcreado] ([id_cv_creado_id])
GO
ALTER TABLE [dbo].[JFlex_referenciascv] CHECK CONSTRAINT [JFlex_referenciascv_cv_creado_id_6cb0d15d_fk_JFlex_cvcreado_id_cv_creado_id]
GO
ALTER TABLE [dbo].[JFlex_registrousuarios]  WITH CHECK ADD  CONSTRAINT [JFlex_registrousuarios_tipo_usuario_id_11d035ec_fk_JFlex_tipousuario_id_tipo_user] FOREIGN KEY([tipo_usuario_id])
REFERENCES [dbo].[JFlex_tipousuario] ([id_tipo_user])
GO
ALTER TABLE [dbo].[JFlex_registrousuarios] CHECK CONSTRAINT [JFlex_registrousuarios_tipo_usuario_id_11d035ec_fk_JFlex_tipousuario_id_tipo_user]
GO
ALTER TABLE [dbo].[JFlex_voluntariadocv]  WITH CHECK ADD  CONSTRAINT [JFlex_voluntariadocv_cv_creado_id_3753bde5_fk_JFlex_cvcreado_id_cv_creado_id] FOREIGN KEY([cv_creado_id])
REFERENCES [dbo].[JFlex_cvcreado] ([id_cv_creado_id])
GO
ALTER TABLE [dbo].[JFlex_voluntariadocv] CHECK CONSTRAINT [JFlex_voluntariadocv_cv_creado_id_3753bde5_fk_JFlex_cvcreado_id_cv_creado_id]
GO
ALTER TABLE [dbo].[JFlex_ofertalaboral]  WITH CHECK ADD CHECK  (([vistas]>=(0)))
GO
